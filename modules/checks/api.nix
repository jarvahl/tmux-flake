{ config, lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      hjem = lib.evalModules {
        modules = [
          config.flake.hjemModules.default
          ({ lib, ... }: {
            options.packages = lib.mkOption {
              type = lib.types.listOf lib.types.package;
              default = [ ];
            };
            options.files = lib.mkOption {
              type = lib.types.attrs;
              default = { };
            };
            options.user.linger = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };
            options.systemd.services = lib.mkOption {
              type = lib.types.attrs;
              default = { };
            };
          })
          {
            tmux.initConfig = lib.mkAfter "set -g @api-test yes";
          }
        ];
        specialArgs = { inherit pkgs; };
      };
      services = hjem.config.systemd.services;
      tmuxConf = hjem.config.files.".config/tmux/tmux.conf".source;
      zsh = lib.evalModules {
        modules = [
          ../../zsh-modules/default.nix
          ({ lib, ... }: {
            options.initConfig = lib.mkOption {
              type = lib.types.lines;
              default = "";
            };
            config.integrations.zsh.enable = true;
          })
        ];
      };
    in
    {
      checks.api = pkgs.runCommand "tmux-flake-api" { } ''
        grep -q '@api-test yes' ${tmuxConf}
        grep -q 'tj()' ${pkgs.writeText "zsh-init" zsh.config.initConfig}
        test '${toString hjem.config.user.linger}' = 1
        test '${toString (services.tmux-sessions-restore.requires)}' = 'tmux-sessions-start.service'
        test '${toString (services.tmux-sessions-default.requires)}' = 'tmux-sessions-restore.service'
        test '${toString (services.tmux-sessions-restore.after)}' = 'tmux-sessions-start.service'
        test '${toString (services.tmux-sessions-default.after)}' = 'tmux-sessions-restore.service'
        touch "$out"
      '';
    };
}
