{ config, pkgs, lib, ... }:

with pkgs;
let
  customPkgs = {
    torchmetric = callPackage ../packages/python-torchmetric { };
  };

  # common scientific packages
  scientificPackages = with python39Packages; [
    jupyter
    numpy
    opencv4
    ipython
    matplotlib
    pandas
    pillow
    scikit-learn
    scipy
  ];

  # deep learning framework
  pytorchPackages =  with python39Packages; [
    # pytorchWithCuda TODO: use overlays
    torchvision
    pytorch-lightning  # keras - pytorch version
    customPkgs.torchmetric      # pytorch-lightning metrics package
    # albumentations   # nixos dont have
    tensorflow-tensorboard
  ];
in {
  nixpkgs.overlays = [
    (import ../overlays)  # just fix version
  ];

  environment.systemPackages = with pkgs; [ 
    cudatoolkit
    cudnn
    nccl
    magma
    pytorch
  ];

  hardware.opengl.enable = true;
  hardware.opengl.setLdLibraryPath = true;
}