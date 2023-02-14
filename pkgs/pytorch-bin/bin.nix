self: super:
{
  pytorch-bin = with self.python3Packages; (
    (pytorch-bin.override { })
      .overrideAttrs (o: {
        version = "1.10.1";
        srcs = import ./binary-hashes.nix version;
      })
  );
}
