{ mkDerivation, base, data-default, ghcjs-dom, jsaddle, jsaddle-dom
, ref-tf, reflex, reflex-dom, stdenv, text, dependent-sum-template
, dependent-map
}:
mkDerivation {
  pname = "google-maps-reflex";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends = [
    base data-default ghcjs-dom jsaddle jsaddle-dom ref-tf reflex
    reflex-dom text dependent-sum-template dependent-map
  ];
  testHaskellDepends = [ base ];
  homepage = "https://github.com/cfraz98/reflex-dom-google-maps#readme";
  license = stdenv.lib.licenses.bsd3;
}
