{ pkgs, ... }:

with pkgs;

{
  # cuda runtime libraries
  cudnn_cudatoolkit = (import ./cudnn { pkgs=pkgs; }).cudnn_cudatoolkit;
  cudatoolkit = (import ./cudatoolkit { pkgs=pkgs; }).cudatoolkit;
  nccl = callPackage ./nccl { cudatoolkit=cudatoolkit; };

  # machine learning & deep learning libraries
  python-torchmetric = callPackage ./python-torchmetric { };
}