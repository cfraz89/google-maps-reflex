with import ../../reflex-platform {};

let
    hie = ghc.callPackage ../hie.nix {};
    example = ghc.callPackage ./google-maps-reflex-example.nix {};
    project = nixpkgs.haskell.lib.addBuildDepends example [hie];
in
workOn ghc project
