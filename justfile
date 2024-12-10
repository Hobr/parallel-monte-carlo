install:
    cargo install hvm bend-lang
    julia -e 'using Pkg; Pkg.add(["Distributions", "DistributedArrays", "RandomNumbers", "MKL", "LoopVectorization", "VSL", "CUDA", "Distributed", "Plots", "BenchmarkTools", "TimerOutputs"])'

fortran-gcc:
    gfortran -o fortran/gcc fortranc/gcc.f90

fortran-intel:
    ifort -o fortran/intel fortran/intel.f90

fortran-nvidia:
    nvfortran -o fortran/nvidia fortran/nvidia.f90

fortran: fortran-gcc fortran-intel fortran-nvidia

bend-c:
    bend run-c bend/main.bend

bend-rust:
    bend run-rust bend/main.bend

bend-gpu:
    bend run-cu bend/main.bend

bend: bend-c bend-rust bend-gpu

julia:
    julia julia/main.jl

fmt:
    pre-commit run --all-files

update:
    cargo install hvm bend-lang
    julia -e 'using Pkg; Pkg.update()'
    pre-commit autoupdate
    nix flake update
