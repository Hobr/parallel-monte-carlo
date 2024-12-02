cpp:
  cd cpp && clang++ -std=c++17 -Wall -Wextra -Wpedantic -Werror -o main main.cpp
  cd ../

rust:
  cd rust && cargo run
  cd ../

bend:
  cd bend && bend run-cu main.bend
  cd ../

fmt:
  cd rust && cargo check
  cd ../
  pre-commit run --all-files

install-dev:
  pre-commit install
  cargo install cargo-edit cargo-deny typos-cli
  cd rust && cargo deny fetch
  cd ../

update:
  nix flake update
  pre-commit autoupdate
  cd rust && cargo upgrade
  cd rust && cargo update
  cd ../
