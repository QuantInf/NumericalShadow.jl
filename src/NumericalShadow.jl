module NumericalShadow
#  import Base.print, Base.show, Base.repl_show
  export numerical_range,random_ket_complex,random_ket_real,random_ket_complex_entangled,random_ket_real_entangled,random_ket_complex_separable,random_ket_real_separable,random_orthogonal,numerical_shadow,get_bounding_box, random_ket_complex_nfold, numerical_shadow_real_integrated
#, plot_shadow

  include(joinpath(Pkg.dir(), "NumericalShadow", "src", "numericalrange.jl"))
  include(joinpath(Pkg.dir(), "NumericalShadow", "src", "utils.jl"))
  include(joinpath(Pkg.dir(), "NumericalShadow", "src", "numericalshadow.jl"))

#  include(joinpath(Pkg.dir(), "NumericalShadow", "src", "plotshadow.jl"))
end
