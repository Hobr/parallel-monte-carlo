install:
    cargo install hvm bend-lang
    julia -e 'using Pkg; Pkg.add(["Distributions", "DistributedArrays", "RandomNumbers", "Statistics", "MKL", "LoopVectorization", "VSL", "CUDA", "Distributed", "Plots", "BenchmarkTools", "TimerOutputs", "JuliaFormatter"])'
    docker pull intel/cpp-essentials:latest

cpp-gcc:
    g++ -std=c++17 -o dist/gcc cpp/main.cpp
    ./dist/gcc

cpp-intel:
    sudo docker run -it --rm -v $(pwd):/workspace intel/cpp-essentials bash -c "cd /workspace && icpx -o dist/intel cpp/main.cpp -O3 -march=native -qopt-zmm-usage=high -qopt-streaming-stores=always -ffast-math -ipo -static -qopenmp -march=native -mtune=native -fvectorize -falign-functions=32 -qmkl"
    sudo docker run -it --rm -v $(pwd):/workspace intel/cpp-essentials bash -c "cd /workspace && icpx -o dist/intel cpp/main.cpp -qopt-report=max -qopt-report-phase=vec"
    ./dist/intel

cpp: cpp-gcc cpp-intel

julia:
    julia julia/main.jl

bend-c:
    bend run-c bend/main.bend

bend-rust:
    bend run-rs bend/main.bend

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
