(import ../reflex-platform {}).project ({ pkgs, ... }: {
  packages = {
    maps = ./.;
  };

  shells = {
    ghc = ["maps"];
    ghcjs = ["maps"];
  };
})
