.PHONY: backup-zplug
backup-zplug: \
	zsh/zplug-$(shell date "+%Y-%m-%d").tar.bz2

.PHONY: backup-tmux-plugins
backup-tmux-plugins: \
	tmux/tmux-plugins-$(shell date "+%Y-%m-%d").tar.bz2

zsh/zplug-%.tar.bz2: zsh/zplug
	cd zsh && tar -cjf "$(shell basename "$@")" zplug

tmux/tmux-plugins-%.tar.bz2: tmux/plugins
	cd tmux && tar -cjf "$(shell basename "$@")" plugins
