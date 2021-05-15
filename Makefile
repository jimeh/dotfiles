links:
	./install.sh links

terminfo:
	./install.sh terminfo

launch-agents:
	./install.sh launch-agents

#
# Backups
#

.PHONY: backup-tmux-plugins
backup-tmux-plugins: \
	tmux/tmux-plugins-$(shell date "+%Y-%m-%d").tar.bz2

tmux/tmux-plugins-%.tar.bz2: tmux/plugins
	cd tmux && tar -cjf "$(shell basename "$@")" plugins
