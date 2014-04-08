type Ket{T}
  dim::Int
end

type KetMaxBipartEntangled{T}
  dim::Int
end

type KetSeparable{T}
  dims::Vector{Int64}
  
  KetSeparable(dims::Vector{Int64}) = new(dims)
  KetSeparable(dims::Int64...) = new([dims...])
end

function rand{T}(d::KetSeparable{T})
  return reduce(kron, [rand(T(i)) for i in d.dims])
end

function rand{T<:Complex}(d::Ket{T})
  c=randn(d.dim)+1im*randn(d.dim)
  return c/norm(c)
end

function rand{T<:Real}(d::Ket{T})
  c=randn(d.dim)
  return c/norm(c)
end

function rand{T<:Complex}(d::KetMaxBipartEntangled{T})
  sqrts=int(sqrt(d.dim))
  U1=random_unitary(sqrts)
  U2=random_unitary(sqrts)
  state=zeros(T,(d.dim,1))
  for i=[1:sqrts]
      state+=kron(U1[:,i],U2[:,i])
  end
  return (1.0/sqrt(sqrts))*state
end

function rand{T<:Real}(d::KetMaxBipartEntangled{T})
  sqrts=int(sqrt(d.dim))
  U1=random_orthogonal(sqrts)
  U2=random_orthogonal(sqrts)
  state=zeros(T,(d.dim,1))
  for i=[1:sqrts]
      state+=kron(U1[:,i],U2[:,i])
  end
  return (1.0/sqrt(sqrts))*state
end

function random_ket_complex_bifold_separable(s::Int)
  sqrts=int(sqrt(s))
  U=random_unitary(sqrts)
  state=zeros(Complex,(s,1))
  state[1]=1
  return kron(U,U)*state
end 

function random_ket_real_bifold_separable(s::Int)
  sqrts=int(sqrt(s))
  U=random_orthogonal(sqrts)
  state=zeros(FloatingPoint,(s,1))
  state[1]=1
  return kron(U,U)*state
end 

function random_mixed_state(s::Int)
  G=randn(s,s)+1im*randn(s,s)
  GGH=G*G'
  return GGH/trace(GGH)
end
