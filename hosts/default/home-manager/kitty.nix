{ config, pkgs, inputs, ... }:

{
  programs.kitty = {
	enable = true;
    settings = {
      confirm_os_window_close = 0;
      paste_actions = "replace-dangerous-control-codes,replace-newline";
      allow_remote_control = "yes";
    };
    extraConfig = "include ~/.cache/wal/colors-kitty.conf";
  };
}