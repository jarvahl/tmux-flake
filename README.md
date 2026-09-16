# tmux-flake

Reusable tmux configuration and session persistence as Nix modules.

## Configuration

```nix
{
  mouse.enable = true;
  mode = "vi";

  windows = {
    baseIndex = 1;
    paneBaseIndex = 1;
    renumber = true;
  };

  history.limit = 50000;
  prefix2 = "Home";

  extendedKeys = {
    enable = true;
    format = "csi-u";
  };

  persistence.enable = true;
}
```

Add `inputs.tmux-flake.hjemModules.default` to Hjem's extra modules to install
this configuration, its packages, and its user-session services.

Run the configured tmux with:

```console
nix run
```

### Extending Tmux with Custom Modules

You can extend the generated configuration from another module. Personal
bindings and status styling belong in the consuming configuration:

```nix
{
  imports = [ inputs.tmux-flake.hjemModules.default ];

  tmux.initConfig = lib.mkAfter ''
    bind | split-window -h -c "#{pane_current_path}"
    bind - split-window -v -c "#{pane_current_path}"
    set -g status-style "bg=#161616,fg=#f2f4f8"
  '';
}
```

Disable persistence when only the tmux configuration and package are needed:

```nix
persistence.enable = false;
```

## Zsh integration

Import `inputs.tmux-flake.zshModules.default` into the `zsh-flake` module list
and enable it explicitly:

```nix
{
  imports = [ inputs.tmux-flake.zshModules.default ];
  integrations.zsh.enable = true;
}
```

This adds `t`, `tl`, `tks`, `tj`, `tjh`, `tk`, and tmux-session completion.
