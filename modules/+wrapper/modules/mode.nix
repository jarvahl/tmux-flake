{ config, lib, ... }:
{
  options.tmux.mode = lib.mkOption {
    type = lib.types.enum [ "emacs" "vi" ];
    default = "vi";
    description = "Key mode used by tmux copy mode.";
  };

  config.tmux.initConfig = lib.mkBefore ''
    set -g mode-keys ${config.tmux.mode}
  '';
}
