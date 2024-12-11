install:
    cargo install hvm bend-lang
    julia -e 'using Pkg; Pkg.add(["Distributions", "DistributedArrays", "RandomNumbers", "Statistics", "MKL", "LoopVectorization", "VSL", "CUDA", "Distributed", "Plots", "BenchmarkTools", "TimerOutputs", "JuliaFormatter"])'
    sudo docker pull intel/fortran-essentials:latest

gfortran:
    gfortran -O3 -march=native -fopenmp -o dist/gcc fortran/main.f90
    ./dist/gcc

ifx:
    sudo docker run -it --rm -v $(pwd):/workspace intel/fortran-essentials bash -c "cd /workspace && ifx -O3 -march=native -qopenmp -o dist/intel fortran/main.f90 && ./dist/intel"

fortran: gfortran ifx

julia:
    julia julia/main.jl

bend-c:
    bend run-c bend/main.bend

bend-rust:
    bend run-rs bend/main.bend

bend-gpu:
    bend run-cu bend/main.bend

bend: bend-c bend-rust bend-gpu

build: fortran julia bend

fmt:
    pre-commit run --all-files

update:
    cargo install hvm bend-lang
    julia -e 'using Pkg; Pkg.update()'
    pre-commit autoupdate
    nix flake update
