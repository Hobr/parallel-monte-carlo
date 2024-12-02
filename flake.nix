{
  description = "Rust Shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      rust-overlay,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [
          rust-overlay.overlays.default
          (final: prev: {
            rustToolchain =
              let
                rust = prev.rust-bin;
              in
              if builtins.pathExists ./rust-toolchain.toml then
                rust.fromRustupToolchainFile ./rust-toolchain.toml
              else if builtins.pathExists ./rust-toolchain then
                rust.fromRustupToolchainFile ./rust-toolchain
              else
                rust.stable.latest.default.override {
                  channel = "1.82.0";
                  extensions = [
                    "rust-src"
                    "rustfmt"
                    "rust-analyzer"
                    "clippy"
                    "cargo"
                  ];
                };
          })
        ];
        pkgs = import nixpkgs {
          inherit overlays system;
          config = {
            allowUnfree = true;
            cudaSupport = true;
          };
        };
      in
      {
        devShells.default =
          with pkgs;
          mkShell rec {
            packages = [
              # 基础
              pkg-config
              openssl

              # 工具
              just
              pre-commit

              # CPP
              clang
              clang-tools
              mold
              cmake
              gdb
              llvmPackages.openmp
              mpi

              # Rust
              rustToolchain

              # Bend
              bend
              hvm

              # CUDA
              linuxPackages.nvidia_x11_beta
              cudatoolkit
              cudaPackages.cudnn
            ];

            env = {
              # Rust
              CARGO_HOME = builtins.toString ".cargo";
              RUSTUP_HOME = builtins.toString ".rustup";
              RUST_SRC_PATH = "${pkgs.rustToolchain}/lib/rustlib/src/rust/library";
              RUSTFLAGS = "-C link-arg=-fuse-ld=mold";

              # CUDA
              CUDA_PATH = "${pkgs.cudatoolkit}";
              LD_LIBRARY_PATH = "${pkgs.linuxPackages.nvidia_x11_beta}/lib:${pkgs.ncurses5}/lib";
              EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11_beta}/lib";
              EXTRA_CCFLAGS = "-I/usr/include";
            };

            shellHook = ''
              export PATH="$PWD/${env.CARGO_HOME}/bin:$PATH"
            '';
          };
      }
    );
}
