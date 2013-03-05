function numerical_shadow(M::Matrix,sampling_function,samples::Int, xdensity::Int, ydensity::Int)
  pts=zeros(Complex128,samples)
  M=complex(M)
  for i=[1:samples]
    s=size(M)[1]
    v=sampling_function(s)
    pt=(v'*M*v)
    pts[i]=pt[1]
  end
  data=hcat(real(pts),imag(pts))
  return histogram2d(data,xdensity,ydensity)
end