with import <nixpkgs> {};
with import ../reflex-platform {};

let 
    hie = ghc.callPackage ./hie.nix {};
    project = haskell.lib.addBuildTools (ghc.callPackage ./google-maps-reflex.nix {}) [hie];
in
workOn ghc project
