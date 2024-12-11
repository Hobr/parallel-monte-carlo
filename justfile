CFLAGS := "-std=c++17 -O3"
INCLUDE := "-Icpp/algorithm -Icpp/util cpp/main.cpp"

install:
    cargo install hvm bend-lang
    julia -e 'using Pkg; Pkg.add(["Distributions", "DistributedArrays", "RandomNumbers", "Statistics", "MKL", "LoopVectorization", "VSL", "CUDA", "Distributed", "Plots", "BenchmarkTools", "TimerOutputs", "JuliaFormatter"])'
    sudo docker pull intel/cpp-essentials:latest

cpp-gcc:
    g++ {{CFLAGS}} {{INCLUDE}} -march=native -fopenmp -o dist/gcc
    ./dist/gcc

cpp-intel:
    sudo docker run -it --rm -v $(pwd):/workspace intel/cpp-essentials bash -c "cd /workspace && icpx {{CFLAGS}} {{INCLUDE}} -qopt-report=max -qopt-report-phase=vec -qopt-zmm-usage=high -qopt-streaming-stores=always -ffast-math -ipo -static -mtune=native -fvectorize -falign-functions=32 -qmkl -march=native -qopenmp -o dist/intel"
    ./dist/intel

cpp-cuda:
    nvcc {{CFLAGS}} {{INCLUDE}} -Xcompiler "-march=native -fopenmp" -o dist/cuda
    ./dist/cuda

cpp: cpp-gcc cpp-intel cpp-cuda

julia:
    julia julia/main.jl

bend-c:
    bend run-c bend/main.bend

bend-rust:
    bend run-rs bend/main.bend

bend-gpu:
    bend run-cu bend/main.bend

bend: bend-c bend-rust bend-gpu

build: cpp julia bend

fmt:
    pre-commit run --all-files

update:
    cargo install hvm bend-lang
    julia -e 'using Pkg; Pkg.update()'
    pre-commit autoupdate
    nix flake update
