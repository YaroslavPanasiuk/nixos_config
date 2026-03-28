{
  description = "AutoSubs packaged for NixOS";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = pkgs.stdenv.mkDerivation rec {
      pname = "auto-subs";
      version = "3.0.8";

      src = pkgs.fetchurl {
        url = "https://github.com/tmoroney/auto-subs/releases/download/v3.0.8/AutoSubs-linux-x86_64.deb";
        hash = "sha256-sbzmIRdo3zXL09AikFxEvUJDWUa7t+YA5e0sXbhPRpE=";
      };

      nativeBuildInputs = with pkgs; [
        dpkg
        autoPatchelfHook
        makeWrapper
      ];

      buildInputs = with pkgs; [
        alsa-lib
        atk
        cairo
        cups
        dbus
        expat
        fontconfig
        freetype
        gdk-pixbuf
        glib
        gtk3
        mesa
        nspr
        nss
        pango
        systemd
        xorg.libX11
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXrandr
        xorg.libxcb
        webkitgtk_4_1
        libsoup_3
        openssl
      ];

      unpackPhase = ''
        dpkg -x $src source
      '';

      installPhase = ''
        mkdir -p $out/bin $out/share
        mkdir -p $out/share/DaVinciResolve/Fusion/Scripts/Utility/
        mkdir -p $out/share/DaVinciResolve/Fusion/Modules/Lua/

        # Dynamically locate the Lua files 
        LUA_SCRIPT=$(find source -name "AutoSubs.lua" | head -n 1)
        MODULES_DIR=$(dirname $(find source -name "autosubs_core.lua" | head -n 1))

        cp "$LUA_SCRIPT" $out/share/DaVinciResolve/Fusion/Scripts/Utility/
        cp "$MODULES_DIR"/*.lua $out/share/DaVinciResolve/Fusion/Modules/Lua/
        
        # Remove bundled ffmpeg and ffprobe to avoid autoPatchelfHook errors
        rm -f source/usr/bin/ffmpeg source/usr/bin/ffprobe
        
        cp -r source/usr/bin/* $out/bin/
        cp -r source/usr/share/* $out/share/ 2>/dev/null || true
      '';

      postFixup = ''
        wrapProgram $out/bin/autosubs \
          --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.ffmpeg ]}
      '';
    };
  };
}