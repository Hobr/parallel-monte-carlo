install:
    cargo install hvm bend-lang
    julia -e 'using Pkg; Pkg.add(["Distributions", "DistributedArrays", "RandomNumbers", "Statistics", "MKL", "LoopVectorization", "VSL", "CUDA", "Distributed", "Plots", "BenchmarkTools", "TimerOutputs", "JuliaFormatter"])'
    sudo docker pull intel/fortran-essentials:latest

fpm:
    cd fortran && fortran-fpm run

G_FLAG := "-O3 -march=native -fopenmp -fcoarray=single"
M_FLAG := "-O3 -march=native -fcoarray=single"
I_FLAG := "-O3 -march=native -coarray -qopenmp -qmkl"

SRC := "fortran/src"
APP := "fortran/app"
DIST := "fortran/build"

THREADS := "4"

gfortran:
    gfortran {{G_FLAG}} -c -J{{SRC}} -o {{SRC}}/base.o {{SRC}}/base.f90
    gfortran {{G_FLAG}} -c -J{{SRC}} -o {{SRC}}/monte.o {{SRC}}/monte.f90
    gfortran {{G_FLAG}} -c -J{{SRC}} -o {{SRC}}/stratified.o {{SRC}}/stratified.f90
    gfortran {{G_FLAG}} -c -J{{SRC}} -o {{SRC}}/importance.o {{SRC}}/importance.f90
    gfortran {{G_FLAG}} -c -J{{SRC}} -o {{SRC}}/quasi.o {{SRC}}/quasi.f90
    gfortran {{G_FLAG}} -c -J{{APP}} -I{{SRC}} -o {{APP}}/main.o {{APP}}/main.f90

    gfortran {{G_FLAG}} -I{{SRC}} -I{{APP}} -o {{DIST}}/gcc {{APP}}/main.o {{SRC}}/base.o {{SRC}}/monte.o {{SRC}}/stratified.o {{SRC}}/importance.o {{SRC}}/quasi.o
    ./{{DIST}}/gcc

mpif:
    mpif90 {{M_FLAG}} -c -J{{SRC}} -o {{SRC}}/base.o {{SRC}}/base.f90
    mpif90 {{M_FLAG}} -c -J{{SRC}} -o {{SRC}}/monte.o {{SRC}}/monte.f90
    mpif90 {{M_FLAG}} -c -J{{SRC}} -o {{SRC}}/stratified.o {{SRC}}/stratified.f90
    mpif90 {{M_FLAG}} -c -J{{SRC}} -o {{SRC}}/importance.o {{SRC}}/importance.f90
    mpif90 {{M_FLAG}} -c -J{{SRC}} -o {{SRC}}/quasi.o {{SRC}}/quasi.f90
    mpif90 {{M_FLAG}} -c -J{{APP}} -I{{SRC}} -o {{APP}}/main.o {{APP}}/main.f90

    mpif90 {{M_FLAG}} -I{{SRC}} -I{{APP}} -o {{DIST}}/mpif90 {{APP}}/main.o {{SRC}}/base.o {{SRC}}/monte.o {{SRC}}/stratified.o {{SRC}}/importance.o {{SRC}}/quasi.o
    mpirun -np {{THREADS}} {{DIST}}/mpif

ifx:
    sudo docker run -it --rm -v $(pwd):/workspace intel/fortran-essentials bash -c "\
        cd /workspace && \
        ifx {{I_FLAG}} -c -module {{SRC}} -o {{SRC}}/base.o {{SRC}}/base.f90 && \
        ifx {{I_FLAG}} -c -module {{SRC}} -o {{SRC}}/monte.o {{SRC}}/monte.f90 && \
        ifx {{I_FLAG}} -c -module {{SRC}} -o {{SRC}}/stratified.o {{SRC}}/stratified.f90 && \
        ifx {{I_FLAG}} -c -module {{SRC}} -o {{SRC}}/importance.o {{SRC}}/importance.f90 && \
        ifx {{I_FLAG}} -c -module {{SRC}} -o {{SRC}}/quasi.o {{SRC}}/quasi.f90 && \
        ifx {{I_FLAG}} -c -module {{APP}} -I{{SRC}} -o {{APP}}/main.o {{APP}}/main.f90 && \
        ifx {{I_FLAG}} -I{{SRC}} -I{{APP}} -o {{DIST}}/intel {{APP}}/main.o {{SRC}}/base.o {{SRC}}/monte.o {{SRC}}/stratified.o {{SRC}}/importance.o {{SRC}}/quasi.o && \
        {{DIST}}/intel"

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
