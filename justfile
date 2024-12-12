M_FLAG := "-O3 -march=native -openmp -lmpi"
I_FLAG := "-O3 -march=native -qopenmp -lmpi -qmkl"

THREADS := "4"

normal:
    gfortran -O3 -march=native src/normal.f90 -o dist/normal
    ./dist/normal

openmp-g:
    gfortran -O3 -march=native -openmp src/omp.f90 -o dist/omp-g
    ./dist/omp-g

openmp-i:
    sudo docker run -it --rm -v $(pwd):/workspace intel/fortran-essentials bash -c "\
        cd /workspace && \
        mpiifx -O3 -march=native -qopenmp -qmkl -qopenmp src/omp.f90 -o dist/omp-i && \
        ./dist/omp-i"

hybrid-g:
    mpif90 -O3 -fopenmp src/hybrid.f90 -o dist/hybrid-g
    mpirun -np {{THREADS}} ./dist/hybrid-g

hybrid-i:
    sudo docker run -it --rm -v $(pwd):/workspace intel/fortran-essentials bash -c "\
        cd /workspace && \
        mpiifx -O3 -march=native -qopenmp -lmpi -qmkl -qopenmp src/hybrid.f90 -o dist/hybrid-i && \
        mpirun -np {{THREADS}} ./dist/hybrid-i"

all: normal openmp-g openmp-i hybrid-g hybrid-i

install:
    sudo docker pull intel/fortran-essentials:latest

update:
    pre-commit autoupdate
    nix flake update

fmt:
    pre-commit run --all-files

pdf:
    pdftk report/封面.pdf report/report.pdf cat output report/报告.pdf
