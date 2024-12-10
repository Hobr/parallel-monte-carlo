install:
    cargo install hvm bend-lang
    julia -e 'using Pkg; Pkg.add(["Distributions", "DistributedArrays", "RandomNumbers", "MKL", "LoopVectorization", "VSL", "CUDA", "Distributed", "Plots", "BenchmarkTools", "TimerOutputs"])'
    docker pull intel/cpp-essentials:latest

cpp-gcc:
    gfortran -o fortran/gcc fortranc/gcc.f90

cpp-intel:
    ifort -o fortran/intel fortran/intel.f90

cpp: cpp-gcc cpp-intel

julia:
    julia julia/main.jl

bend-c:
    bend run-c bend/main.bend

bend-rust:
    bend run-rust bend/main.bend

bend-gpu:
    bend run-cu bend/main.bend

bend: bend-c bend-rust bend-gpu

fmt:
    pre-commit run --all-files

update:
    cargo install hvm bend-lang
    julia -e 'using Pkg; Pkg.update()'
    pre-commit autoupdate
    nix flake update
