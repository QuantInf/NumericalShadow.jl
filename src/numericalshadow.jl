function numerical_shadow(M::Matrix,sampling_function::Function,samples::Int, xdensity::Int, ydensity::Int)
  pts=zeros(Complex128,samples)
  M=complex(M)
  s=size(M)[1]
  for i=1:samples
    v=sampling_function(s)
    pt=(v'*M*v)
    pts[i]=pt[1]
  end
  data=hcat(real(pts),imag(pts))
  bb=get_bounding_box(M)
  return histogram2d(data,bb[1:2],bb[3:4],xdensity,ydensity)
end

function numerical_shadow_parallel(M::Matrix,sampling_function::Function,samples::Int, xdensity::Int, ydensity::Int)
  samples_per_process=div(samples,nprocs())
  samples_for_first_proc=samples_per_process+mod(samples,nprocs())
  
  hist=zeros(Int64,xdensity,ydensity)
  refs={}
  for id=1:nprocs()
    if id==1
      remote_ref=remote_call(id, numerical_shadow,M,sampling_function,samples_for_first_proc, xdensity, ydensity)
    else
      remote_ref=remote_call(id, numerical_shadow,M,sampling_function,samples_per_process, xdensity, ydensity)
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
      remote_ref=remote_call(id, numerical_shadow_diagonal,M,eigs,samples_for_first_proc, xdensity, ydensity)
    else
      remote_ref=remote_call(id, numerical_shadow_diagonal,M,eigs,samples_per_process, xdensity, ydensity)
    end
    append!(refs,{remote_ref})
  end
  for remote_ref in refs
    hist+=fetch(remote_ref)
  end
  return hist
end
