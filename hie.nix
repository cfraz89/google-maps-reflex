{ stdenv, fetchFromGitHub, haskell, haskellPackages }:

with haskell.lib;
let hie-src = stdenv.mkDerivation {
      name = "haskell-ide-engine";
      src = fetchFromGitHub {
        owner = "haskell";
        repo = "haskell-ide-engine";
        rev = "cc71e5bdbb58351712d3bdf8b42caa4153bb6c78";
        sha256 = "0w7mapn5yl9n4ymjwkf3cijacsgd1sfj2f795lv65yhrnxfrbymj";
      };
      phases = ["unpackPhase" "buildPhase"];
      buildPhase = ''
        for p in hie-apply-refact hie-base hie-build-plugin hie-example-plugin2 hie-eg-plugin-async hie-plugin-api hie-ghc-mod hie-ghc-tree hie-hare hie-hoogle hie-brittany hie-haddock
        do
          cp ./LICENSE ./$p/LICENSE
          sed -i "s/..\/LICENSE/LICENSE/" ./$p/$p.cabal
        done
        cp -r ./ $out
      '';
    };
in (haskellPackages.extend (self: super: {
    foundation = dontCheck super.foundation;
    process-extras = dontCheck super.process-extras;
    monad-memo = dontCheck super.monad-memo;
    multistate = dontCheck super.multistate;

    hlint = dontCheck (self.callCabal2nix "hlint" (fetchFromGitHub {
      owner = "ndmitchell";
      repo = "hlint";
      rev = "v2.0.9";
      sha256 = "1zljl8nfvj8r3z19gdfpldrvf1apznlvwrp96yf50akql0niam3n";
    }) {});
    apply-refact = dontCheck (self.callCabal2nix "apply-refact" (fetchFromGitHub {
      owner = "mpickering";
      repo = "apply-refact";
      rev = "v0.3.0.1";
      sha256 = "15cac2vg307k95bm1d02kgbs48vxbmfi7r4di1rpsgmabpg6jyp5";
    }) {});
    lens = dontCheck (self.callCabal2nix "lens" (fetchFromGitHub {
      owner = "ekmett";
      repo = "lens";
      rev = "v4.15.3";
      sha256 = "1vfdy6mbpari5ldhh6r054f9ab67svz8q2bapzzmkhbf90jyi5jl";
    }) {});
    ghc-exactprint = dontCheck (self.callCabal2nix "ghc-exactprint" (fetchFromGitHub {
      owner = "alanz";
      repo = "ghc-exactprint";
      rev = "v0.5.4.0";
      sha256 = "0x6s319s427l3p2j6bwfj59k4iii4kh214klmwm4b6bn385yfdqi";
    }) {});
    hoogle = dontCheck (self.callCabal2nix "hoogle" (fetchFromGitHub {
      owner = "ndmitchell";
      repo = "hoogle";
      rev = "v5.0.13";
      sha256 = "06nyjn17hcyp4i9llfzsqmiwygil8d1z7axwnaq933gscbf51gld";
    }) {});

    haskell-lsp = dontHaddock (self.callCabal2nix "haskell-lsp" (fetchFromGitHub {
      owner = "alanz";
      repo = "haskell-lsp";
      rev = "beeab9fc8a98dee87ee7291e7191dee762d90b6d";
      sha256 = "1mcpvvc493bq85pfa3gqf4kbg2zfa70k4189zzc01ngdjs90rixw";
    }) {});
    ghc-dump-tree = self.callCabal2nix "ghc-dump-tree" (fetchFromGitHub {
      owner = "alanz";
      repo = "ghc-dump-tree";
      rev = "50f8b28fda675cca4df53909667c740120060c49";
      sha256 = "0v3r81apdqp91sv7avy7f0s3im9icrakkggw8q5b7h0h4js6irqj";
    }) {};
    /*hspec-jenkins = self.callCabal2nix "hspec-jenkins" (fetchFromGitHub {
      owner = "sol";
      repo = "hspec-jenkins";
      rev = "cb012b23c4e524dde9ea129b6146dda20a5ca505";
      sha256 = "0ngi2cx3wyynxgyk2ggk54vb8c4kqdj2dn02mwzlgs7iiv6p43nf";
    }) {};*/
    HaRe = dontCheck (self.callCabal2nix "HaRe" (fetchFromGitHub {
      owner = "alanz";
      repo = "HaRe";
      rev = "e325975450ce89d790ed3f92de3ef675967d9538";
      sha256 = "0z7r3l4j5a1brz7zb2rgd985m58rs0ki2p59y1l9i46fcy8r9y4g";
    }) {});
    ghc-mod = dontCheck (self.callCabal2nix "ghc-mod" (fetchFromGitHub {
      owner = "alanz";
      repo = "ghc-mod";
      rev = "5f9d4bb74e495563a66b9d36945b00e5d8936cb4";
      sha256 = "162s8swg1b026wgif7kdhc48l658p268614b0syn1vn46vlybx88";
    }) { shelltest = null; });
    ghc-mod-core = dontCheck (self.callCabal2nix "ghc-mod-core" ((fetchFromGitHub {
      owner = "alanz";
      repo = "ghc-mod";
      rev = "c9b209c08779b2166300dc2ec69d7f5bb2955eb3";
      sha256 = "182ggv5g766nfzlgz5dh6wkficl2rfxpys4dlg9bblwqc1q46asi";
    }) + "/core") {});
    cabal-helper = dontCheck (self.callCabal2nix "cabal-helper" (fetchFromGitHub {
      owner = "nh2"; # change back to alanz when https://github.com/alanz/cabal-helper/pull/1 is merged
      repo = "cabal-helper";
      rev = "68f45e22554e90fbc332ba402236ec96d3139be7";
      sha256 = "0l0ssmz0zb7m8hi1hzz371h02h5wa3v6f6m6pvg1ai42rkcdwzqb";
    }) {});
    brittany = dontCheck (self.callCabal2nix "brittany" (fetchFromGitHub {
      owner = "alanz";
      repo = "brittany";
      rev = "32a193f0ce02ec36a6032852454db96573ab3a60";
      sha256 = "0hnvzfgqpx9kr252iq1iwd8kchrf3lgiijp94m751l7zckkd352r";
    }) {});
    haskell-ide-engine = dontCheck (self.callCabal2nix "haskell-ide-engine" hie-src {});
    hie-apply-refact = self.callCabal2nix "hie-apply-refact" "${hie-src}/hie-apply-refact" {};
    hie-base = self.callCabal2nix "hie-base" "${hie-src}/hie-base" {};
    hie-build-plugin = dontHaddock (self.callCabal2nix "hie-build-plugin" "${hie-src}/hie-build-plugin" {});
    hie-example-plugin2 = self.callCabal2nix "hie-example-plugin2" "${hie-src}/hie-example-plugin2" {};
    hie-eg-plugin-async = self.callCabal2nix "hie-eg-plugin-async" "${hie-src}/hie-eg-plugin-async" {};
    hie-plugin-api = self.callCabal2nix "hie-plugin-api" "${hie-src}/hie-plugin-api" {};
    hie-ghc-mod = self.callCabal2nix "hie-ghc-mod" "${hie-src}/hie-ghc-mod" {};
    hie-ghc-tree = self.callCabal2nix "hie-ghc-tree" "${hie-src}/hie-ghc-tree" {};
    hie-hare = self.callCabal2nix "hie-hare" "${hie-src}/hie-hare" {};
    hie-hoogle = self.callCabal2nix "hie-hoogle" "${hie-src}/hie-hoogle" {};
    hie-brittany = self.callCabal2nix "hie-brittany" "${hie-src}/hie-brittany" {};
    hie-haddock = self.callCabal2nix "hie-haddock" "${hie-src}/hie-haddock" {};
    /*hie-docs-generator = self.callCabal2nix "hie-docs-generator" "${hie-src}/hie-docs-generator" {};*/
  })).haskell-ide-engine
