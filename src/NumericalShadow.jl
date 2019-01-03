module NumericalShadow
using QuantumInformation
using LinearAlgebra
#  import Base.print, Base.show, Base.repl_show
  export numericalrange, random_ket_complex,
  random_ket_real,random_ket_complex_entangled,random_ket_real_entangled,
  random_ket_complex_separable,random_ket_real_separable,random_orthogonal,
  numerical_shadow,get_bounding_box,
  random_ket_complex_nfold,
  numerical_shadow_real_integrated,
  BoundingBox, boundingbox
#, plot_shadow

  BoundingBox{T} = NamedTuple{(:xmin, :xmax, :ymin, :ymax), NTuple{4, T}} where T<:Real
  boundingbox(xmin::T, xmax::T, ymin::T, ymax::T) where T<:Real = BoundingBox{T}((xmin, xmax, ymin, ymax))

  include("numericalrange.jl")
  include("randomstates.jl")
  include("randommatrix.jl")
  include("utils.jl")
  include("numericalshadow.jl")

#  include("plotshadow.jl"))
end
