{
  description = "Rust Shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
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
              pre-commit
              just

              # Fortran
              gfortran
              openblas
              fortran-fpm
              fortls

              # Julia
              julia-bin

              # Rust
              rustc
              cargo

              # 库
              mpich
              mkl

              # Typst
              typst
              typstyle
              tinymist

              # CUDA
              cudatoolkit
              cudaPackages.nccl
              cudaPackages.cuda_nvcc
              cudaPackages.cuda_cudart
            ];

            env = {
              # CUDA
              CUDA_PATH = "${pkgs.cudatoolkit}";
              LD_LIBRARY_PATH = "/run/opengl-driver/lib:/run/opengl-driver-32/lib:${pkgs.ncurses5}/lib";
              EXTRA_CCFLAGS = "-I/usr/include";

              # Julia
              JULIA_PKG_SERVER = "https://mirrors.ustc.edu.cn/julia";

              # Rust
              CARGO_HOME = builtins.toString ".cargo";
            };

            shellHook = ''
              export PATH="$PWD/${env.CARGO_HOME}/bin:/run/opengl-driver/bin:$PATH"
              export OMP_NUM_THREADS=8
            '';
          };
      }
    );
}
