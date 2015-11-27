using FactCheck
using NumericalShadow

facts("numerical_range") do
  J = [[0 1]; [0 0]]
  res = numerical_range(J)
  r = map(abs2, res)
  @fact norm(r - 0.25) --> roughly(0, atol=1e-10)
  @fact typeof(res) --> Vector{Complex128}
end
