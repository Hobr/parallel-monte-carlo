using CUDA
using LinearAlgebra
using MKL

println(CUDA.versioninfo())
println(BLAS.get_config())
