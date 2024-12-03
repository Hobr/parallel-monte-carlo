run: run-c run-rust

run-rust:
  cargo run

run-c:
  build/cpp_dist

build: build-c build-rust

build-rust:
  cargo build

build-c:
  g++ -fopenmp -mavx -O3 algorithm-c/main.cpp -o build/cpp_dist

fmt:
  cargo check
  pre-commit run --all-files

install:
  pre-commit install
  cargo deny fetch
  cargo install hvm bend-lang

update:
  nix flake update
  pre-commit autoupdate
  cargo upgrade
  cargo update
