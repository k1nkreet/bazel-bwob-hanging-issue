{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = [
      pkgs.buildPackages.bazelisk
      pkgs.buildPackages.grpcurl
    ];
}

