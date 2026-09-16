{ config, lib, ... }:
{
  options.tmux.mouse.enable = lib.mkEnableOption "tmux mouse support" // { default = true; };

  config.tmux.initConfig = lib.mkBefore ''
    set -g mouse ${if config.tmux.mouse.enable then "on" else "off"}
  '';
}
