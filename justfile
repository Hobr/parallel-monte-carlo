cpp:
  g++ -fopenmp -mavx -O3 cpp/main.cpp -o cpp_res

rust:
  cd rust && cargo run
  cd ../

bend-c:
  bend run-c bend/main.bend

bend-rust:
  bend run-rs bend/main.bend

bend-cuda:
  bend run-cu bend/main.bend

fmt:
  cd rust && cargo check
  cd ../
  pre-commit run --all-files

install-dev:
  pre-commit install
  cargo install cargo-deny typos-cli
  cd rust && cargo deny fetch
  cd ../

update:
  nix flake update
  pre-commit autoupdate
  cd rust && cargo upgrade
  cd ../
