{ stdenv, lib, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "albumentations";
  version = "1.0.2";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1ivjh7zxx3yyw63r4fxrm1b3qcyypalavdrl94czm1hhn1l8qx9m";
  };

  propagatedBuildInputs = with python3Packages; [
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

  meta = with lib; {
    homepage = "https://github.com/PyTorchLightning/metrics";
    description = "Machine learning metrics for distributed, scalable PyTorch applications.";
    license = licenses.gpl3Plus;
    longDescription = ''
      TorchMetrics is a collection of 25+ PyTorch metrics implementations and an easy-to-use API to create custom metrics. It offers:
        - A standardized interface to increase reproducibility
        - Reduces boilerplate
        - Automatic accumulation over batches
        - Metrics optimized for distributed-training
        - Automatic synchronization between multiple devices
      You can use TorchMetrics with any PyTorch model or with PyTorch Lightning to enjoy additional features such as:
        - Module metrics are automatically placed on the correct device.
        - Native support for logging metrics in Lightning to reduce even more boilerplate.
    '';
    maintainers = with maintainers; [ MoozIiSP ];
  };
}