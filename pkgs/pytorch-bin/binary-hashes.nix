# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "1.10.1" = {
    aarch64-darwin-39 = {
      name = "torch-1.10.1-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.10.1-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-VkQoDYjFtt4n6swNkR+Wiq1BpLqyl69N9eVxvAkn0+Q=";
    };
  };
}
