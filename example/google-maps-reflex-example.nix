{ mkDerivation, callCabal2nix, callPackage, 
  base, bytestring, containers, data-default, jsaddle, mtl,
  reflex, reflex-dom, stdenv, text, lens, ghc, jsaddle-warp, pkgs 
 }:
let
    google-maps-reflex = callPackage ../google-maps-reflex.nix {};
in
mkDerivation {
  pname = "google-maps-reflex-example";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base bytestring containers data-default jsaddle mtl reflex reflex-dom 
    text lens google-maps-reflex
   ]
    #foundation is stuffed on ghcjs darwin
 ++ (if !(ghc.isGhcjs or false && stdenv.isDarwin) then  [ jsaddle-warp ] else []);
  license = stdenv.lib.licenses.unfree;
}
