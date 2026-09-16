{ lib, ... }:
{
  options.tmux = {
    initConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Tmux configuration text.";
    };

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Packages used by the tmux configuration.";
    };
  };
}
