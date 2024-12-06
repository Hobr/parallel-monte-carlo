install:
    cargo install hvm bend-lang

fortran-gcc:
    gfortran -o fortran/gcc fortranc/main.f90

fortran-intel:
    ifort -o fortran/intel fortran/main.f90

fortran-nvidia:
    nvfortran -o fortran/nvidia fortran/main.f90

julia:
    julia julia/main.jl

bend-c:
    bend run-c bend/main.bend

bend-rust:
    bend run-rust bend/main.bend

bend-gpu:
    bend run-cu bend/main.bend

fmt:
    pre-commit run --all-files
