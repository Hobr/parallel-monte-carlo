install:
    cargo install hvm bend-lang
    julia -e 'using Pkg; Pkg.add(["Distributions", "DistributedArrays", "RandomNumbers", "Statistics", "MKL", "LoopVectorization", "VSL", "CUDA", "Distributed", "Plots", "BenchmarkTools", "TimerOutputs", "JuliaFormatter"])'
    sudo docker pull intel/fortran-essentials:latest

fpm:
    cd fortran && fortran-fpm run

FLAG := "-O3 -march=native -fopenmp -fcoarray=single"
SRC := "fortran/src"
APP := "fortran/app"

gfortran:
    gfortran {{FLAG}} -c -J{{SRC}} -o {{SRC}}/base.o {{SRC}}/base.f90
    gfortran {{FLAG}} -c -J{{SRC}} -o {{SRC}}/monte.o {{SRC}}/monte.f90
    gfortran {{FLAG}} -c -J{{SRC}} -o {{SRC}}/stratified.o {{SRC}}/stratified.f90
    gfortran {{FLAG}} -c -J{{SRC}} -o {{SRC}}/importance.o {{SRC}}/importance.f90
    gfortran {{FLAG}} -c -J{{SRC}} -o {{SRC}}/quasi.o {{SRC}}/quasi.f90
    gfortran {{FLAG}} -c -J{{APP}} -I{{SRC}} -o {{APP}}/main.o {{APP}}/main.f90

    gfortran {{FLAG}} -I{{SRC}} -I{{APP}} -o fortran/build/gcc {{APP}}/main.o {{SRC}}/base.o {{SRC}}/monte.o {{SRC}}/stratified.o {{SRC}}/importance.o {{SRC}}/quasi.o
    ./fortran/build/gcc

mpif:
    mpif90 -O3 -march=native -fcoarray=single -c -J{{SRC}} -o {{SRC}}/base.o {{SRC}}/base.f90
    mpif90 -O3 -march=native -fcoarray=single -c -J{{SRC}} -o {{SRC}}/monte.o {{SRC}}/monte.f90
    mpif90 -O3 -march=native -fcoarray=single -c -J{{SRC}} -o {{SRC}}/stratified.o {{SRC}}/stratified.f90
    mpif90 -O3 -march=native -fcoarray=single -c -J{{SRC}} -o {{SRC}}/importance.o {{SRC}}/importance.f90
    mpif90 -O3 -march=native -fcoarray=single -c -J{{SRC}} -o {{SRC}}/quasi.o {{SRC}}/quasi.f90
    mpif90 -O3 -march=native -fcoarray=single -c -J{{APP}} -I{{SRC}} -o {{APP}}/main.o {{APP}}/main.f90

    mpif90 -O3 -march=native -fcoarray=single -I{{SRC}} -I{{APP}} -o fortran/build/mpif90 {{APP}}/main.o {{SRC}}/base.o {{SRC}}/monte.o {{SRC}}/stratified.o {{SRC}}/importance.o {{SRC}}/quasi.o
    mpirun -np 8 fortran/build/mpif90

ifx:
    sudo docker run -it --rm -v $(pwd):/workspace intel/fortran-essentials bash -c "\
        cd /workspace && \
        ifx -O3 -march=native -coarray -qopenmp -qmkl -c -module {{SRC}} -o {{SRC}}/base.o {{SRC}}/base.f90 && \
        ifx -O3 -march=native -coarray -qopenmp -qmkl -c -module {{SRC}} -o {{SRC}}/monte.o {{SRC}}/monte.f90 && \
        ifx -O3 -march=native -coarray -qopenmp -qmkl -c -module {{SRC}} -o {{SRC}}/stratified.o {{SRC}}/stratified.f90 && \
        ifx -O3 -march=native -coarray -qopenmp -qmkl -c -module {{SRC}} -o {{SRC}}/importance.o {{SRC}}/importance.f90 && \
        ifx -O3 -march=native -coarray -qopenmp -qmkl -c -module {{SRC}} -o {{SRC}}/quasi.o {{SRC}}/quasi.f90 && \
        ifx -O3 -march=native -coarray -qopenmp -qmkl -c -module {{APP}} -I{{SRC}} -o {{APP}}/main.o {{APP}}/main.f90 && \
        ifx -O3 -march=native -coarray -qopenmp -qmkl -I{{SRC}} -I{{APP}} -o fortran/build/intel {{APP}}/main.o {{SRC}}/base.o {{SRC}}/monte.o {{SRC}}/stratified.o {{SRC}}/importance.o {{SRC}}/quasi.o && \
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
