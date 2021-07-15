{ pkgs, ... }:

with pkgs;
let
  cuda = callPackage ../cudatoolkit {};
  generic = args: callPackage (import <nixpkgs/pkgs/development/libraries/science/math/cudnn/generic.nix> (removeAttrs args ["cudatoolkit"])) {
    inherit (args) cudatoolkit;
  };
in 
rec {
  cudnn_cudatoolkit_11_1 = generic rec {
    version = "8.1.1";
    cudatoolkit = cuda.cudatoolkit_11_1;
    # 8.1.1 is compatible with CUDA 11.0, 11.1, and 11.2:
    # https://docs.nvidia.com/deeplearning/cudnn/support-matrix/index.html#cudnn-cuda-hardware-versions
    srcName = "cudnn-11.2-linux-x64-v8.1.1.33.tgz";
    hash = "sha256-mKh4TpKGLyABjSDCgbMNSgzZUfk2lPZDPM9K6cUCumo=";
  };

  cudnn_cudatoolkit_11_3 = generic rec {
    version = "8.2.1";
    cudatoolkit = cuda.cudatoolkit_11_3;
    # 8.2.1 is compatible with CUDA 11.x
    srcName = "cudnn-11.3-linux-x64-v8.2.1.32.tgz";
    hash = "sha256-mKh4TpKGLyABjSDCgbMNSgzZUfk2lPZDPM9K6cUCumo=";
  };

  cudnn_cudatoolkit = cudnn_cudatoolkit_11_3;
}