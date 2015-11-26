using Tensors
using FactCheck

my_tests = ["hosvd.jl"]

println("Running tests:")

for my_test in my_tests
    include(my_test)
end
