{ config, inputs, lib, ... }:
let
  baseModules = [
    ./modules/options.nix
    ./modules/mouse.nix
    ./modules/mode.nix
    ./modules/windows.nix
    ./modules/history.nix
    ./modules/prefix.nix
    ./modules/extended-keys.nix
    ./modules/persistence.nix
  ];

  evalTmuxModules =
    { pkgs
    , modules ? [ ]
    , specialArgs ? { }
    ,
    }:
    lib.evalModules {
      modules = baseModules ++ config.tmux.modules ++ modules;
      specialArgs = {
        inherit pkgs inputs;
      } // specialArgs;
    };

  tmuxConfigText =
    { pkgs
    , modules ? [ ]
    , specialArgs ? { }
    ,
    }:
    (evalTmuxModules { inherit pkgs modules specialArgs; }).config.tmux.initConfig;

  tmuxConfiguration =
    { pkgs
    , modules ? [ ]
    , specialArgs ? { }
    ,
    }:
    let
      tmuxConf = pkgs.writeText "tmux.conf" (tmuxConfigText {
        inherit pkgs modules specialArgs;
      });
    in
    pkgs.runCommand "tmux-config" { buildInputs = [ pkgs.makeWrapper ]; } ''
      mkdir -p $out/bin
      makeWrapper ${lib.getExe pkgs.tmux} $out/bin/tmux \
        --add-flags "-f ${tmuxConf}"
    '';
in
{
  flake.lib.evalTmuxModules = evalTmuxModules;
  flake.lib.tmuxConfigText = tmuxConfigText;
  flake.lib.tmuxConfiguration = tmuxConfiguration;
  flake.zshModules.default = ../../zsh-modules/default.nix;
}
