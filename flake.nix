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
              cookiecutter

              # CUDA
              cudatoolkit
              cudaPackages.cudnn
              cudaPackages.nccl
              cudaPackages.cuda_cudart
            ];

            env = {
              # CUDA
              CUDA_PATH = "${pkgs.cudatoolkit}";
              LD_LIBRARY_PATH = "/run/opengl-driver/lib:/run/opengl-driver-32/lib:${pkgs.ncurses5}/lib:${pkgs.lib.makeLibraryPath packages}";
              EXTRA_CCFLAGS = "-I/usr/include";
            };

            shellHook = ''
              export PATH="/run/opengl-driver/bin:$PATH"
            '';
          };
      }
    );
}
