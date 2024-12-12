{
  description = "Rust Shell";

  inputs = {
    nixpkgs.url = "nixpkgs";
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
              pdftk

              # Fortran
              gfortran
              openblas
              fortran-fpm
              fortls

              # 库
              mpich
              mkl

              # Typst
              typst
              typstyle
              tinymist
            ];

            shellHook = ''
              export OMP_NUM_THREADS=8
            '';
          };
      }
    );
}
