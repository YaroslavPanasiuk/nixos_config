# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal NixOS flake configuration for a single-user Hyprland desktop (NVIDIA GPU, Ukrainian locale).
It builds both a `nixosConfiguration` (system) and a `homeConfiguration` (home-manager) for the `default`
host. A `public` host is referenced in `flake.nix` (`nixosConfigurations.public`,
`homeConfigurations.public_user`) but `hosts/public/` does not currently exist in this checkout — treat
any work targeting it as needing that directory to be created first.

## Commands

All commands assume the repo lives at `~/nixos` (the flake is keyed off that absolute path via
`nixos-rebuild --flake ~/nixos#<host>`).

- **Rebuild and switch (normal flow):** `rebuild.sh` (installed as a package by
  `hosts/default/scripts/rebuild.nix`) — stages `git add .`, then runs
  `nixos-rebuild switch --flake ~/nixos/#default` under `nvidia-offload`.
- **Rebuild manually:** `sudo nixos-rebuild switch --flake ~/nixos#default`
- **Rollback:** `rebuild.sh --rollback` (rolls back and deletes the now-unreferenced generation)
- **Check flake syntax/evaluation without switching:** `nix flake check` — note this repo has no CI, so
  this is the main cheap correctness check before a real rebuild.
- **Build without activating:** `nixos-rebuild build --flake ~/nixos#default`
- **Rebuild home-manager only:** `home-manager switch --flake ~/nixos#default_user`
- **Update flake inputs:** `nix flake update` (or `nix flake lock --update-input <name>` for one input)
- There are no tests, linters, or formatters configured for this repo (no CI workflow, no `treefmt`/`nixfmt`
  hook). Validate changes by evaluating (`nix flake check`, `nixos-rebuild build`) rather than assuming a
  test suite exists.

## Architecture

### Layout

- `flake.nix` — all inputs (nixpkgs pinned to `nixos-26.05`, home-manager, Hyprland, hyprtasking, and
  several of the user's own flakes: `zen-browser`, `vigiland`, `goal-tracker`, `macro-grid`, `pretested`)
  and the four outputs: `nixosConfigurations.{default,public}`, `homeConfigurations.{default_user,public_user}`,
  plus an `install` package/app wrapping `install.sh`.
- `hosts/default/configuration.nix` — system entry point. Imports `hardware-configuration.nix`, the
  home-manager NixOS module, and everything under `configuration_modules/`. Also wires
  `home-manager.users.${user.name} = import ./home.nix`, so the home-manager config is activated as part
  of `nixos-rebuild switch`, not standalone.
- `hosts/default/configuration_modules/*.nix` — system config split by concern (`boot`, `services`,
  `programs`, `extra_packages`, `fonts`, `hardware`, `filesystems`, `systemd`, `security`, `user`).
  `user.nix` is the single source of truth for the username/home path (`name`/`path`), imported by nearly
  every other module instead of hardcoding `"yaros"` — **always edit identity here, not inline**.
- `hosts/default/home.nix` — home-manager entry point; imports `hosts/default/home-manager/**`. Many
  modules there exist on disk but are commented out of the `imports` list (e.g. `dunst`, `gbar`, `stylix`,
  `rofi/colors-rofi`, `waybar/taskbar`) — they're inactive/experimental, not dead code to delete.
- `hosts/default/home-manager/` — per-program home-manager modules (hyprland, waybar, gtk, kitty, ssh,
  git, anyrun, swayosd, etc.).
- `hosts/default/scripts/*.nix` — **one file per shell script**, each wrapping a script via
  `pkgs.writeShellScriptBin "<name>.sh" ''...''` and taking `{ pkgs }` as input. These are not auto-
  discovered: a script only becomes available system-wide once it is explicitly `import`-ed somewhere,
  almost always as an entry in the `environment.systemPackages` list in
  `configuration_modules/extra_packages.nix` (one `(import ../scripts/<name>.nix { inherit pkgs; })` line
  per script). Some scripts are instead wired as systemd services/timers (see `configuration_modules/systemd.nix`,
  which imports `watchdog.nix`/`sync_folders.nix` directly for the `multi-sync-watcher`/`multi-sync-scheduler`
  user units) or invoked from Hyprland keybinds (`hyprland.lua`) rather than exposed as a package. When adding
  a new script, create the `.nix` wrapper in `scripts/`, then remember to actually reference it from
  `extra_packages.nix` (or wherever it needs to be invoked) — creating the file alone does nothing.
- `hosts/default/home-manager/hyprland/hyprland.lua` — the real Hyprland config, written in **Lua**
  against the `hl` API (hyprlang's Lua config support), not the traditional `.conf` keyword syntax. It's
  pulled in via `extraConfig = builtins.readFile ./hyprland.lua` in `hyprland.nix`. It reads pywal-generated
  colors from `~/.cache/wal/colors-hyprland.lua` at runtime, so theming changes flow from pywal, not from
  edits to this file.
- `hosts/default/derivations/`, `hosts/default/packages/`, `hosts/default/overlays/` — custom package
  derivations and overlays consumed via `nixpkgs.overlays` / `nixpkgs.config.packageOverrides` in
  `configuration.nix`.
- `hosts/default/grub/`, `hosts/default/fonts/` — boot theme assets and bundled font files.
- `hyprtasking/` — a vendored checkout of the `hyprtasking` Hyprland plugin (tracked in this repo as a
  git submodule-style gitlink, but with no `.gitmodules` entry, so plain `git clone`/`pull` here won't
  populate or update it automatically). The actual flake input `hyprtasking` instead fetches the plugin
  straight from `github:raybbian/hyprtasking` pinned to a specific commit in `flake.nix` — the local
  `hyprtasking/` directory is for local plugin development/reference only and is not what gets built.
- `install.sh` — fresh-machine bootstrap (clones the config, patches the username placeholder, copies
  dotfiles/wallpapers, runs the first `nixos-rebuild`, sets up pywal/`walogram`/Flatpak/Samba). This is a
  one-time provisioning script, not something re-run as part of normal iteration.

### Theming

Color theming flows from **pywal** (`wal -i <wallpaper>`), which generates
`~/.cache/wal/colors-hyprland.lua`/`colors-hyprland.conf` etc., consumed at runtime by Hyprland, waybar, and
other components. `home-manager/stylix.nix` exists as an alternative/experimental theming path via the
Stylix module but is **not imported** by `home.nix` and its flake input isn't declared in `flake.nix`, so
it is currently inert.

### Key external integrations

- NVIDIA GPU: `nvidia-offload` prefixes heavy commands (e.g. `rebuild.sh`); `LIBVA_DRIVER_NAME`,
  `GBM_BACKEND`, `__GLX_VENDOR_LIBRARY_NAME` are pinned to nvidia in `configuration.nix`.
- Virtualisation: libvirtd + QEMU/SWTPM, Waydroid, and rootless Docker are all enabled in `configuration.nix`.
- Samba file sharing and a local Postgres instance (`nova_bot` database) are both provisioned directly in
  `configuration_modules/services.nix`.
