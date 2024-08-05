{
  description = "webdriver-w3c";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; config = { allowBroken = true; }; };
        packageName = "webdriver-w3c";
        haskellPackages = pkgs.haskell.packages.ghc981;
        bin = haskellPackages.callCabal2nix "${packageName}" ./. { };
      in with pkgs; rec {
        packages.${packageName} = bin;
        defaultPackage = packages.${packageName};
      }
    );
}
