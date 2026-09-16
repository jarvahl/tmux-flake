{ config, lib, ... }:
{
  options.tmux.windows = {
    baseIndex = lib.mkOption {
      type = lib.types.ints.positive;
      default = 1;
      description = "First window index.";
    };

    paneBaseIndex = lib.mkOption {
      type = lib.types.ints.positive;
      default = 1;
      description = "First pane index.";
    };

    renumber = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Renumber windows after one is closed.";
    };
  };

  config.tmux.initConfig = lib.mkBefore ''
    set -g base-index ${toString config.tmux.windows.baseIndex}
    setw -g pane-base-index ${toString config.tmux.windows.paneBaseIndex}
    set -g renumber-windows ${if config.tmux.windows.renumber then "on" else "off"}
  '';
}
