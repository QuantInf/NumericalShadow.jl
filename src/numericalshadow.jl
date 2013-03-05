function numerical_shadow(M::Matrix,func,samples::Int64)
  pts=zeros(Complex128,samples)
  for i=[1:samples]
    s=size(M)[1]
    v=random_ket_complex(s)
    pt=(v'*M*v)[1]
    pts[i]=pt
  end
  data=hcat(real(pts),imag(pts))
  return histogram2d(data)
end