.PHONY: backup-zplug-cache
backup-zplug-cache:
	cd shell/zsh \
		&& tar -cjf zplug-cache-$(shell date "+%Y-%m-%d").tar.bz2 zplug-cache

.PHONY: backup-tmux-plugins
backup-tmux-plugins:
	cd tmux && tar -cjf tmux-plugins-$(shell date "+%Y-%m-%d").tar.bz2 plugins
