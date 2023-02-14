# ol = 
final: prev: {
  # cuda just only support gcc9 now.
  cudaStdEnv = prev.overrideCC prev.stdenv prev.gcc9;
  nvidia = prev.linuxPackages.nvidia_x11_beta;

  # FIXME Hack it! gcc use default 9 version.
  cudatoolkit = (prev.cudatoolkit_11.overrideAttrs (old: rec {
    version = "11.4.0";
    src = prev.fetchurl {
      url = "https://developer.download.nvidia.cn/compute/cuda/${version}/local_installers/cuda_${version}_470.42.01_linux.run";
      sha256 = "0jxa78i5v92x9h3xdjliz3vih2jbk2sxnax29rd12nj1ywqdn6fj";
    };
    # gcc = prev.gcc;
  })).override {
    # FIXME: gcc10 has some bug
    gcc = prev.gcc9;
  };

  # FIXME Hack it! It doesn't need gcc to compile.
  cudnn = (prev.cudnn_cudatoolkit_11.overrideAttrs (old: rec {
    version = "8.2.2";
    srcName = "cudnn-11.4-linux-x64-v8.2.2.26.tgz";
    src = prev.fetchurl {
      url = "https://developer.download.nvidia.cn/compute/redist/cudnn/v${version}/${srcName}";
      sha256 = "01vfv02hkz79sx8hz3vigyqqay5r1nr06122sbbqg3k837733ipv";
    };
    # FIXME: you should override package name
    name = "cudatoolkit-11.4-cudnn-8.2.2";
  })).override {
    cudatoolkit_11_2 = final.cudatoolkit;
  };

  nccl = (prev.nccl.overrideAttrs (old: rec {
    name = "nccl-${version}-cuda-${(prev.lib.versions.majorMinor final.cudatoolkit.version)}";
    version = "2.10.3-1";
    src = prev.fetchFromGitHub rec {
      owner = "NVIDIA";
      repo = "nccl";
      rev = "v${version}";
      sha256 = "1mjkhmdk61nv1dpx45jl82znznm64mj54wdal2mcbhfbx6l18n3f";
    };
    # disable warning
    makeFlags = old.makeFlags ++ [ "NVCC_GENCODE=\"-gencode=arch=compute_80,code=sm_80\"" ];
  })).override { 
    stdenv = final.cudaStdEnv;
    cudatoolkit = final.cudatoolkit;
  };

  # TODO: you should use python 3.9
  pytorch = prev.python39Packages.pytorch.override {
    stdenv = final.cudaStdEnv;
    cudaSupport = true;
    cudatoolkit = final.cudatoolkit;
    cudnn = final.cudnn;
    nccl = final.nccl;
    magma = final.magma;
    MPISupport = false;  # dist system
    cudaArchList = [ "8.0" "8.0+PTX" "8.6" "8.6+PTX" ];  # just for RTX3090
  };

  # TODO: override magma 2.5.4 to 2.6.0
  magma = (prev.magma.overrideAttrs (old: rec {
    version="2.6.0";
    src = prev.fetchurl rec {
      url = "https://icl.cs.utk.edu/projectsfiles/magma/downloads/magma-${version}.tar.gz";
      sha256="1v1qfqmvx48da7qw6wykflckrqgs5y5my4p7d52a61jgyj2d7kah";
      name = "magma-${version}.tar.gz";
    };
    cmakeFlags = [ 
      "-DCAMKE_BUILD_TYPE=Release"
      "-DBUILD_SHARED_LIBS=ON"
      "-DGPU_TARGET=\"sm_80\"" ];
    enableParallelBuilding=false;
  })).override {
    stdenv = final.cudaStdEnv;
    # NOTE: you should keep this as same as gcc. now it's same.
    gfortran = prev.gfortran9;  
  };

  # blas 3.10.0
}

# pkgs = import <nixpkgs> { overlays = [ol]; }