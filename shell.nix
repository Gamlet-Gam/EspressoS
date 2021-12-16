with import
  (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/a7ecde854aee5c4c7cd6177f54a99d2c1ff28a31.tar.gz";
    # To update hash:
    #   nix-prefetch-url --type sha256 --unpack https://github.com/NixOS/nixpkgs/archive/....tar.gz
    sha256 = "162dywda2dvfj1248afxc45kcrg83appjd0nmdb541hl7rnncf02";
  })
{ };
let
  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "nixpkgs-mozilla";
    rev = "e912ed483e980dfb4666ae0ed17845c4220e5e7c";
    sha256 = "08fvzb8w80bkkabc1iyhzd15f4sm7ra10jn32kfch5klgl0gj3j3";
  };
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  NIGHTLY_DATE = "2021-08-01";
  nixpkgs = import <nixpkgs> { overlays = [ moz_overlay ]; };
  rustNightly = (nixpkgs.rustChannelOf { date = "${NIGHTLY_DATE}"; channel = "nightly"; }).rust.override {
    extensions = [
      "clippy-preview"
      "rustfmt-preview"
      "rust-src"
    ];
  };
in
with import "${src.out}/rust-overlay.nix" pkgs pkgs;
stdenv.mkDerivation {
  name = "rust-env";
  buildInputs = [
    # Note: to use use stable, just replace `nightly` with `stable`
    rustNightly

    # Add some extra dependencies from `pkgs`
    openssl
    pkgconfig
    openssl
    binutils-unwrapped
    cargo-udeps

    alloy5
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  # Set Environment Variables
  RUST_BACKTRACE = 1;

  shellHook = ''
    export PATH="$PATH:./target/debug"
  '';
}
