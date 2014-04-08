function numerical_shadow(M::Hermitian, sampling_function::Function,samples::Int, density::Int)
end

function numerical_shadow{T<:FloatingPoint}(M::Diagonal{T}, sampling_function::Function,samples::Int, density::Int)
end

function numerical_shadow(M::Matrix,sampling_function::Function,samples::Int, xdensity::Int, ydensity::Int)
  samples_per_run=10000
  runs=div(samples,samples_per_run)+1
  println(runs)
  reminder=mod(samples,samples_per_run)
  println(reminder)
  pts=zeros(Complex128,samples_per_run)
  M=complex(M)
  s=size(M)[1]
  hist=zeros(Int64,xdensity,ydensity)
  bb=get_bounding_box(M)
  
  if ishermitian(M) && sampling_function==NumericalShadow.random_ket_complex
    ev=eigvals(M)
    run=1
    while run<=runs
      smp=samples_per_run
      if run==runs
        if reminder==0 break end
	smp=reminder
	pts=zeros(Complex128,smp)
      end
      for i=1:smp
	v=sampling_function(s)
	pt=(v'*(ev.*v))
	pts[i]=pt[1]
      end
      hist+=histogram2d(hcat(real(pts),imag(pts)),bb[1:2],bb[3:4],xdensity,ydensity)
      run+=1      
      println(sum(hist))
    end
  else # not hermitian
    run=1
    while run<=runs
      smp=samples_per_run
      if run==runs
      	if reminder==0 break end
	smp=reminder
	pts=zeros(Complex128,smp)
      end
      for i=1:smp
	v=sampling_function(s)
	pt=(v'*M*v)
	pts[i]=pt[1]
      end
      hist+=histogram2d(hcat(real(pts),imag(pts)),bb[1:2],bb[3:4],xdensity,ydensity)
      run+=1
    end
  end
  return hist
end

function numerical_shadow_parallel(M::Matrix,sampling_function::Function,samples::Int, xdensity::Int, ydensity::Int)
  samples_per_process=div(samples,nprocs())
  samples_for_first_proc=samples_per_process+mod(samples,nprocs())
  
  hist=zeros(Int64,xdensity,ydensity)
  refs={}
  for id=1:nprocs()
    if id==1
      remote_ref=remotecall(id, numerical_shadow,M,sampling_function,samples_for_first_proc, xdensity, ydensity)
    else
      remote_ref=remotecall(id, numerical_shadow,M,sampling_function,samples_per_process, xdensity, ydensity)
    end
    append!(refs,{remote_ref})
  end
  for remote_ref in refs
    hist+=fetch(remote_ref)
  end
  return hist
end

function numerical_shadow_diagonal(M::Matrix, eigs::Array, samples::Int, xdensity::Int, ydensity::Int)
  pts=zeros(Complex128,samples)
  for i=1:samples
    r = rand(int(sqrt(length(eigs))))
    vec = map(x -> reshape(hcat(x, 1-x),(1,2)), r  )
    big_vec = reduce((x,y)->kron(x,y), 1, vec)
    pts[i] = (big_vec*eigs)[1]
  end
  data=hcat(real(pts),imag(pts))
  bb=get_bounding_box(M)
  return histogram2d(data,bb[1:2],bb[3:4],xdensity,ydensity)
end

function numerical_shadow_diagonal_parallel(M::Matrix, eigs::Array,samples::Int, xdensity::Int, ydensity::Int)
  samples_per_process=div(samples,nprocs())
  samples_for_first_proc=samples_per_process+mod(samples,nprocs())
  
  hist=zeros(Int64,xdensity,ydensity)
  refs={}
  for id=1:nprocs()
    if id==1
      remote_ref=remotecall(id, numerical_shadow_diagonal,M,eigs,samples_for_first_proc, xdensity, ydensity)
    else
      remote_ref=remotecall(id, numerical_shadow_diagonal,M,eigs,samples_per_process, xdensity, ydensity)
    end
    append!(refs,{remote_ref})
  end
  for remote_ref in refs
    hist+=fetch(remote_ref)
  end
  return hist
end
