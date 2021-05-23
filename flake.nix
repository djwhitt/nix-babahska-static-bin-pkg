{
  description = "Babashka static binary package flake";

  outputs = { self, nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in rec {
      packages.x86_64-linux.babashka-static-bin =
        let
          p = { stdenv, lib, fetchurl, ... }: pkgs.stdenv.mkDerivation rec {
            name = "babashka-static-bin";
            version = "0.4.3";

            src = fetchurl {
              url = "https://github.com/babashka/babashka/releases/download/v${version}/babashka-${version}-linux-amd64-static.tar.gz";
              sha256 = "sha256-8POym1JtOY8nRBEfr7AdLoRkza2Dpnxe72+w9rCF448=";
            };

            unpackPhase = ''
              tar xvf $src
            '';

            installPhase = ''
              mkdir $out
              mv bb $out/
            '';

            meta = with lib; {
              homepage = https://github.com/babashka/babashka;
              description = "Native, fast starting Clojure interpreter for scripting";
              platforms = platforms.linux;
            };
          };
        in pkgs.callPackage p { };

      defaultPackage.x86_64-linux = packages.x86_64-linux.babashka-static-bin;
    };
}
