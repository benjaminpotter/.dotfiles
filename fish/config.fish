fish_add_path ~/.local/bin
set -x EDITOR {{editor}}

if status is-interactive
	set -g fish_greeting ""
	set -g fish_key_bindings fish_vi_key_bindings
	set -g fish_cursor_default block

	abbr -a sdn sudo shutdown now
	abbr -a sdu sudo dnf update -y
	abbr -a tks tmux kill-server
end

