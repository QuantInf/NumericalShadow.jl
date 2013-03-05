function random_ket_complex(s::Int)
  c=randn(s)+1im*randn(s)
  return c/norm(c)
end

function random_ket_real(s::Int)
  c=randn(s)
  return c/norm(c)
end

function random_ket_complex_entangled(s::Int)
  sqrts=int(sqrt(s))
  U1=random_unitary(sqrts)
  U2=random_unitary(sqrts)
  state=zeros(Complex,(s,1))
  for i=[1:sqrts]
      state+=vkron(U1[:,i],U2[:,i])
  end
  return (1.0/sqrt(sqrts))*state
end

function random_ket_real_entangled(s::Int)
  sqrts=int(sqrt(s))
  U1=random_orthogonal(sqrts)
  U2=random_orthogonal(sqrts)
  state=zeros(Float,(s,1))
  for i=[1:sqrts]
      state+=vkron(U1[:,i],U2[:,i])
  end
  return (1.0/sqrt(sqrts))*state
end

function random_ket_complex_separable(s::Int)
  sqrts=int(sqrt(s))
  return vkron(random_ket_complex(sqrts),random_ket_complex(sqrts))
end

function random_ket_real_separable(s::Int)
  sqrts=int(sqrt(s))
  return vkron(random_ket_real(sqrts),random_ket_real(sqrts))
end

function random_mixed_state(s::Int)
  G=randn(s,s)+1im*randn(s,s)
  GGH=G*G'
  return GGH/trace(GGH)
end