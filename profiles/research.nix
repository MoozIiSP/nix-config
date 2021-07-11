{ config, pkgs, ... }:

let
  customPkgs = [
    (import ../packages/python-torchmetric {})
  ];

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
  pytorchPackages = with python39Packages; [
    pytorchWithCuda
    torchvision
    pytorch-lightning  # keras - pytorch version
    customPkgs.torchmetric      # pytorch-lightning metrics package
    # albumentations   # nixos dont have
    tensorflow-tensorboard
  ];
in {
  environment.systemPackages = with pkgs; with cudaPackages; [ 
    cudatoolkit_11_1
    cudnn_cudatoolkit_11_1
  ] ++ scientificPackages ++ pytorchPackages;

  hardware.opengl.enable = true;
  hardware.opengl.setLdLibraryPath = true;
}