{ config, lib, ... }:
{
  options.integrations.zsh.enable = lib.mkEnableOption "tmux Zsh integration";

  config.initConfig = lib.mkIf config.integrations.zsh.enable (lib.mkAfter ''
    _tmux_session_name() {
      local name="''${1:-default}"

      name="''${name//[^[:alnum:]_-]/-}"
      print -r -- "''${name:-default}"
    }

    alias t='tmux'
    alias tl='tmux list-sessions'
    alias tks='tmux kill-server'

    tj() {
      local session="$(_tmux_session_name "$1")"

      if [ -n "$TMUX" ]; then
        if ! tmux has-session -t "=$session" 2>/dev/null; then
          tmux new-session -d -s "$session" -c "$PWD" || return
        fi
        tmux switch-client -t "=$session"
      elif tmux has-session -t "=$session" 2>/dev/null; then
        tmux attach-session -t "=$session"
      else
        tmux new-session -s "$session" -c "$PWD"
      fi
    }

    tjh() {
      tj "$(basename "$PWD")"
    }

    tk() {
      local session

      if [ -z "$1" ]; then
        print -u2 -- 'usage: tk <session>'
        return 2
      fi

      session="$(_tmux_session_name "$1")"
      tmux kill-session -t "=$session"
    }

    _tmux_session_names() {
      tmux list-sessions -F '#S' 2>/dev/null
    }

    _tmux_session_complete() {
      compadd -- $(_tmux_session_names)
    }

    if (( $+functions[compdef] )); then
      compdef _tmux_session_complete tj
      compdef _tmux_session_complete tk
    fi
  '');
}
