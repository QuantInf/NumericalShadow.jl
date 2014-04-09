abstract RandomState

type Ket{T} <: RandomState
  dim::Int64
end

type KetMaxBipartEntangled{T} <: RandomState
  dim::Int64
end

type KetSeparable{T} <: RandomState
  dims::Vector{Int64}
  
  KetSeparable(dims::Vector{Int64}) = new(dims)
  KetSeparable(dims::Int64...) = new([dims...])
end

type KetBifoldSeparable{T} <: RandomState
  dim::Int64
end

type DensityMatrix <: RandomState
  dim::Int64
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

function  rand{T<:Complex}(d::KetBifoldSeparable{T})
  sqrts=int(sqrt(d.dim))
  U=random_unitary(sqrts)
  state=zeros(T,(d.dim,1))
  state[1]=1
  return kron(U,U)*state
end 

function  rand{T<:Real}(d::KetBifoldSeparable{T})
  sqrts=int(sqrt(d.dim))
  U=random_orthogonal(sqrts)
  state=zeros(T,(d.dim,1))
  state[1]=1
  return kron(U,U)*state
end 

function rand(d::DensityMatrix)
  G=randn(d.dim,d.dim)+1im*randn(d.dim,d.dim)
  GGH=G*G'
  return GGH/trace(GGH)
end
