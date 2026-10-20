(final: prev: {
    varia = prev.varia.overrideAttrs (oldAttrs: {
      propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or []) ++ [
        final.python3Packages.emoji-country-flag
      ];
    });
  })