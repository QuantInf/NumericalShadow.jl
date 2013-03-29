module NumericalShadow
#  import Base.print, Base.show, Base.repl_show
  export numerical_range,random_ket_complex,random_ket_real,random_ket_complex_entangled,random_ket_real_entangled,random_ket_complex_separable,random_ket_real_separable,random_orthogonal,mkron,vkron,numerical_shadow,get_bounding_box
#, plot_shadow

  include(joinpath(Pkg.dir(), "NumericalShadow", "src", "numericalrange.jl"))
  include(joinpath(Pkg.dir(), "NumericalShadow", "src", "radnomstates.jl"))
  include(joinpath(Pkg.dir(), "NumericalShadow", "src", "randommatrix.jl"))
  include(joinpath(Pkg.dir(), "NumericalShadow", "src", "utils.jl"))
  include(joinpath(Pkg.dir(), "NumericalShadow", "src", "numericalshadow.jl"))

#  include(joinpath(Pkg.dir(), "NumericalShadow", "src", "plotshadow.jl"))
end
