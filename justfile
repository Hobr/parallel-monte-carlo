install:
    cargo install hvm bend-lang
    julia -e 'using Pkg; Pkg.add(["Distributions", "DistributedArrays", "RandomNumbers", "Statistics", "MKL", "LoopVectorization", "VSL", "CUDA", "Distributed", "Plots", "BenchmarkTools", "TimerOutputs", "JuliaFormatter"])'
    sudo docker pull intel/fortran-essentials:latest

fpm:
    cd fortran && fortran-fpm run

FLAG := "-O3 -march=native -fopenmp -fcoarray=single"

gfortran:
    gfortran {{FLAG}} -c -o fortran/src/base.o fortran/src/base.f90
    gfortran {{FLAG}} -c -o fortran/src/monte.o fortran/src/monte.f90
    gfortran {{FLAG}} -c -o fortran/src/stratified.o fortran/src/stratified.f90
    gfortran {{FLAG}} -c -o fortran/src/importance.o fortran/src/importance.f90
    gfortran {{FLAG}} -c -o fortran/src/quasi.o fortran/src/quasi.f90
    gfortran {{FLAG}} -c -o fortran/app/main.o fortran/app/main.f90

    gfortran {{FLAG}} -o fortran/build/gcc fortran/app/main.o fortran/src/base.o fortran/src/monte.o fortran/src/stratified.o fortran/src/importance.o fortran/src/quasi.o
    ./fortran/build/gcc

mpif:
    mpif90 -O3 -march=native -fcoarray=single -c -o fortran/src/base.o fortran/src/base.f90
    mpif90 -O3 -march=native -fcoarray=single -c -o fortran/src/monte.o fortran/src/monte.f90
    mpif90 -O3 -march=native -fcoarray=single -c -o fortran/src/stratified.o fortran/src/stratified.f90
    mpif90 -O3 -march=native -fcoarray=single -c -o fortran/src/importance.o fortran/src/importance.f90
    mpif90 -O3 -march=native -fcoarray=single -c -o fortran/src/quasi.o fortran/src/quasi.f90
    mpif90 -O3 -march=native -fcoarray=single -c -o fortran/app/main.o fortran/app/main.f90

    mpif90 -O3 -march=native -fcoarray=single -o fortran/build/mpif90 fortran/app/main.o fortran/src/base.o fortran/src/monte.o fortran/src/stratified.o fortran/src/importance.o fortran/src/quasi.o
    mpirun -np 8 fortran/build/mpif90

ifx:
    sudo docker run -it --rm -v $(pwd):/workspace intel/fortran-essentials bash -c "\
        cd /workspace && \
        ifx -O3 -march=native -coarray -qopenmp -qmkl -c -o fortran/src/base.o fortran/src/base.f90 && \
        ifx -O3 -march=native -coarray -qopenmp -qmkl -c -o fortran/src/monte.o fortran/src/monte.f90 && \
        ifx -O3 -march=native -coarray -qopenmp -qmkl -c -o fortran/src/stratified.o fortran/src/stratified.f90 && \
        ifx -O3 -march=native -coarray -qopenmp -qmkl -c -o fortran/src/importance.o fortran/src/importance.f90 && \
        ifx -O3 -march=native -coarray -qopenmp -qmkl -c -o fortran/src/quasi.o fortran/src/quasi.f90 && \
        ifx -O3 -march=native -coarray -qopenmp -qmkl -c -o fortran/app/main.o fortran/app/main.f90 && \
        ifx -O3 -march=native -coarray -qopenmp -qmkl -o fortran/build/intel fortran/app/main.o fortran/src/base.o fortran/src/monte.o fortran/src/stratified.o fortran/src/importance.o fortran/src/quasi.o && \
        fortran/build/intel"

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
