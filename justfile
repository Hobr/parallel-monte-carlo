install:
    cargo install hvm bend-lang
    julia -e 'using Pkg; Pkg.add(["Distributions", "DistributedArrays", "RandomNumbers", "Statistics", "MKL", "LoopVectorization", "VSL", "CUDA", "Distributed", "Plots", "BenchmarkTools", "TimerOutputs", "JuliaFormatter"])'
    sudo docker pull intel/fortran-essentials:latest

fpm:
    cd fortran && fortran-fpm run

gfortran:
    gfortran -O3 -march=native -fopenmp -fcoarray=single -o fortran/build/gcc fortran/app/main.f90
    ./fortran/build/gcc

mpif:
    mpif90 -O3 -march=native -fcoarray=single -o fortran/build/mpif90 fortran/app/main.f90
    mpirun -np 8 fortran/build/mpif90

ifx:
    sudo docker run -it --rm -v $(pwd):/workspace intel/fortran-essentials bash -c "cd /workspace && ifx -O3 -march=native -coarray -qopenmp -qmkl -o fortran/build/intel fortran/app/main.f90 && fortran/build/intel"

fortran: fpm gfortran mpif ifx

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
