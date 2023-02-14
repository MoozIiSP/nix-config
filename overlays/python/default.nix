# For aarch64-darwin
final: prev:

let
  # inherit just like import, which will import some function from another set into this set.
  inherit (prev) python3 fetchPypi fetchurl isPy39;
  inherit (prev.python) pythonVersion;
  inherit (prev.python3.pkgs) buildPythonPackage;
in

{
  python3 = python3.override {
    packageOverrides = self: super: {
      # Custom Package here!
      # pytorch bundle with build 20220402 version
      # nix hash to-sri --type sha256 (nix-prefetch-url "$url" --name "$name")

      # NOTE: Using nixpkgs version
      # pytorch-bin = (
      #   (super.pytorch-bin.override { })
      #     .overridePythonAttrs (o: with prev; rec {
      #       pname = "pytorch";
      #       version = "1.11.0";

      #       src = fetchurl {
      #         name = "torch-1.10.1-cp310-none-macosx_11_0_arm64.whl";
      #         url = "https://download.pytorch.org/whl/cpu/torch-1.10.1-cp310-none-macosx_11_0_arm64.whl";
      #         hash = "sha256-VkQoDYjFtt4n6swNkR+Wiq1BpLqyl69N9eVxvAkn0+Q=";
      #       };
      #     })
      # );
      # torchvision-bin = (
      #   (super.torchvision-bin.override { })
      #     .overridePythonAttrs (o: with prev; rec {
      #       pname = "torchvision";
      #       version = "0.13.0.dev20220402";

      #       src = fetchurl {
      #         name = "torchvision-0.13.0.dev20220402-cp310-cp310-macosx_10_9_arm64.whl";
      #         url = "https://download.pytorch.org/whl/nightly/torchvision-0.13.0.dev20220402-cp310-cp310-macosx_10_9_arm64.whl";
      #         hash = "sha256-IeCdHDycRgWNjdjC2RcO97kR0v+iz+4Pb/SVH2NCY94=";
      #       };
      #     })
      # );

      torchaudio-bin = (
        (super.torchaudio-bin.override { })
          .overridePythonAttrs (o: with prev; rec {
            pname = "torchaudio";
            version = "1.10.1";

            src = fetchurl {
              name = "torch-1.10.1-cp310-none-macosx_11_0_arm64.whl";
              url = "https://download.pytorch.org/whl/cpu/torch-1.10.1-cp310-none-macosx_11_0_arm64.whl";
              hash = "sha256-VkQoDYjFtt4n6swNkR+Wiq1BpLqyl69N9eVxvAkn0+Q=";
            };
          })
      );

      torchtext-bin = buildPythonPackage rec {
        pname = "pytorch";
        version = "1.12.0.dev20220308";

        # Don't forget to update pytorch to the same version.

        format = "wheel";

        disabled = with prev; !(python?isPy310 || python?isPy39);

        src = fetchurl {
          name = "torch-1.12.0.dev20220308-cp39-none-macosx_11_0_arm64.whl";
          url = "https://download.pytorch.org/whl/nightly/cpu/torch-1.12.0.dev20220308-cp39-none-macosx_11_0_arm64.whl";
          hash = "sha256-US3Z9jWZpJULwQ54lPjYng+T5//yVtXBLQe9smMAdNU=";
        };

        nativeBuildInputs = with prev; [
          addOpenGLRunpath
          patchelf
        ];

        propagatedBuildInputs = with prev.python3.pkgs; [
          future
          numpy
          pyyaml
          requests
          setuptools
          typing-extensions
        ];

        postInstall = ''
          # ONNX conversion
          rm -rf $out/bin
        '';

        postFixup = let
          rpath = prev.lib.makeLibraryPath [ prev.stdenv.cc.cc.lib ];
        in ''
          find $out/${prev.python3.sitePackages}/torch/lib -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
          echo "setting rpath for $lib..."
          patchelf --set-rpath "${rpath}:$out/${prev.python3.sitePackages}/torch/lib" "$lib"
            addOpenGLRunpath "$lib"
          done
        '';

        # The wheel-binary is not stripped to avoid the error of `ImportError: libtorch_cuda_cpp.so: ELF load command address/offset not properly aligned.`.
        dontStrip = true;

        pythonImportsCheck = [ "torch" ];

      };

      torchdata-bin = buildPythonPackage rec {
        pname = "pytorch";
        version = "0.4.0.dev20220402";

        format = "wheel";

        src = fetchurl {
          name = "torchdata-0.4.0.dev20220402-py3-none-any.whl";
          url = "https://download.pytorch.org/whl/nightly/torchdata-0.4.0.dev20220402-py3-none-any.whl";
          hash = "sha256-eLcQkKGMiLKd4oqZuwESd1lo6sstaSrDtke5NYWL7XQ=";
        };

        nativeBuildInputs = with prev; [
          addOpenGLRunpath
          patchelf
        ];

        propagatedBuildInputs = with prev.python3.pkgs; [
          future
          numpy
          pyyaml
          requests
          setuptools
          typing-extensions
        ];

        postInstall = ''
          # ONNX conversion
          rm -rf $out/bin
        '';

        postFixup = let
          rpath = prev.lib.makeLibraryPath [ prev.stdenv.cc.cc.lib ];
        in ''
          find $out/${prev.python3.sitePackages}/torch/lib -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
          echo "setting rpath for $lib..."
          patchelf --set-rpath "${rpath}:$out/${prev.python3.sitePackages}/torch/lib" "$lib"
            addOpenGLRunpath "$lib"
          done
        '';

        # The wheel-binary is not stripped to avoid the error of `ImportError: libtorch_cuda_cpp.so: ELF load command address/offset not properly aligned.`.
        dontStrip = true;

        pythonImportsCheck = [ "torch" ];

      };

      torchmetrics = buildPythonPackage rec {
        pname = "torchmetrics";
        version = "0.6.2";

        src = fetchPypi {
          inherit pname version;
          sha256 = "1ggz9qw31f3z8b8b7r1kmqyfjirw5r4b3ns94s63phqh4a0hzi9g";
        };

        propagatedBuildInputs = with prev.python3.pkgs; [ numpy pytorch packaging ];

        doCheck = false;
      };

      albumtations = buildPythonPackage rec {
        pname = "albumentations";
        version = "1.0.2";

        src = fetchPypi {
          inherit pname version;
          sha256 = "1ivjh7zxx3yyw63r4fxrm1b3qcyypalavdrl94czm1hhn1l8qx9m";
        };

        propagatedBuildInputs = with prev.python3.pkgs; [
          Augmentor
          imgaug
          keras
          numpy
          opencv4
          pandas
          pillow-simd
          pytablewriter
          solt
          tensorflow # required for keras
          torchvision
          tqdm
        ];

        doCheck = false;
      };

      augmentor = buildPythonPackage rec {
        pname = "Augmentor";
        version = "0.2.8";

        src = fetchPypi {
          inherit pname version;
          sha256 = "1i6z53wy02k603af5lpfxmxnzdn0pp1k8fdylq9sjclhr81w4ii8";
        };

        propagatedBuildInputs = with prev.python3.pkgs; [
          pillow
          future
          # futures
          tqdm
          numpy
        ];

        doCheck = false;
      };

      # EAF
      mac-app-frontmost = buildPythonPackage rec {
        pname = "mac-app-frontmost";
        version = "2020.12.3";

        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-tjBQpSTxtM3eZm6DrkUJTNVz5Dzvmrn6VISo5fkf0b8=";
        };

        propagatedBuildInputs = with prev.python3.pkgs; [ sexpdata ];

        doCheck = false;
      };
    };
  };
}
