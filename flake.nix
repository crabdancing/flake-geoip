{
  description = "A simple flake to extract MMDB from the nixpkgs opensearch package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
        opensearchVer = pkgs.opensearch;
      in {
        packages.geoip-db = pkgs.stdenv.mkDerivation {
          name = "geoip-db";
          buildInputs = [pkgs.coreutils];

          buildCommand = ''
            mkdir -p "$out/share/db"
            cp -r "${opensearchVer}/modules/ingest-geoip/"*.mmdb "$out/share/db"
          '';
        };

        packages.default = self.packages.${system}.geoip-db;
      }
    );
}
