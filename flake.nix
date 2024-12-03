{
  description = "Rust Shell";

  inputs = {
    nixpkgs.url = "nixpkgs";
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
                  channel = "1.83.0";
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
              gcc
              gdb
              llvmPackages.openmp
              mpi
              cmake

              # Rust
              rustToolchain
              cargo-deny
              cargo-update
              mold

              # CUDA
              cudatoolkit
              cudaPackages.cudnn
              cudaPackages.nccl
              cudaPackages.cuda_cudart
            ];

            env = {
              # Rust
              CARGO_HOME = builtins.toString ".cargo";
              RUST_SRC_PATH = "${pkgs.rustToolchain}/lib/rustlib/src/rust/library";
              RUSTFLAGS = "-C link-arg=-fuse-ld=mold";

              # CUDA
              CUDA_PATH = "${pkgs.cudatoolkit}";
              LD_LIBRARY_PATH = "/run/opengl-driver/lib:/run/opengl-driver-32/lib:${pkgs.ncurses5}/lib:${pkgs.lib.makeLibraryPath packages}";
              EXTRA_CCFLAGS = "-I/usr/include";
            };

            shellHook = ''
              export PATH="$PWD/${env.CARGO_HOME}/bin:/run/opengl-driver/bin:$PATH"
              unset all_proxy https_proxy http_proxy
            '';
          };
      }
    );
}
