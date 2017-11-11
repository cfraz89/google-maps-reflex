with import ../reflex-platform {};

let
    hie = ghc.callPackage ./hie.nix {};
    maps = ghc.callPackage ./google-maps-reflex.nix {};
    project = nixpkgs.haskell.lib.addBuildDepends maps [hie];
in
workOn ghc project
#maps.env
