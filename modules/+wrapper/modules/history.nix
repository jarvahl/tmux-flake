{ config, lib, ... }:
{
  options.tmux.history.limit = lib.mkOption {
    type = lib.types.ints.positive;
    default = 50000;
    description = "Number of lines retained in scrollback.";
  };

  config.tmux.initConfig = lib.mkBefore ''
    set -g history-limit ${toString config.tmux.history.limit}
  '';
}
