{ pkgs, ... }:

with pkgs;
let
  common = callPackage <nixpkgs/pkgs/development/compilers/cudatoolkit/common.nix>;
  generic = args: callPackage (import <nixpkgs/pkgs/development/libraries/science/math/cudnn/generic.nix> (removeAttrs args ["cudatoolkit"])) {
    inherit (args) cudatoolkit;
  };
in 
rec {
  cudatoolkit_11_1 = common {
    version = "11.1.1";
    url = "https://developer.download.nvidia.com/compute/cuda/11.1.1/local_installers/cuda_11.1.1_455.32.00_linux.run";
    sha256 = "13yxv2fgvdnqqbwh1zb80x4xhyfkbajfkwyfpdg9493010kngbiy";
    # gcc = gcc10;
  };

  cudatoolkit_11_2 = common {
    version = "11.2.2";
    url = "https://developer.download.nvidia.com/compute/cuda/11.2.1/local_installers/cuda_11.2.1_460.32.03_linux.run";
    sha256 = "13yxv2fgvdnqqbwh1zb80x4xhyfkbajfkwyfpdg9493010kngbiy";
    # gcc = gcc10;
  };

  cudatoolkit_11_3 = common {
    version = "11.3.1";
    url = "https://developer.download.nvidia.com/compute/cuda/11.2.1/local_installers/cuda_11.2.1_460.32.03_linux.run";
    sha256 = "13yxv2fgvdnqqbwh1zb80x4xhyfkbajfkwyfpdg9493010kngbiy";
    # gcc = gcc10;
  };

  cudatoolkit_11_4 = common {
    version = "11.4.0";
    url = "https://developer.download.nvidia.com/compute/cuda/11.2.1/local_installers/cuda_11.2.1_460.32.03_linux.run";
    sha256 = "13yxv2fgvdnqqbwh1zb80x4xhyfkbajfkwyfpdg9493010kngbiy";
    # gcc = gcc10;
  };

  cudatoolkit = cudatoolkit_11_3;
}