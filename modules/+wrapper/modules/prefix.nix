{ config, lib, ... }:
{
  options.tmux.prefix2 = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = "Home";
    description = "Secondary tmux prefix key, or null to leave it unchanged.";
  };

  config.tmux.initConfig = lib.mkBefore (
    lib.optionalString (config.tmux.prefix2 != null) "set -g prefix2 ${config.tmux.prefix2}"
  );
}
