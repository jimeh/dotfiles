.SILENT:

#
# Default tasks
#

install:
	make $(DEP_PATHS)

update:
	make $(foreach path,$(DEP_PATHS),$(shell echo "update_$(path)"))

clean:
	make $(foreach path,$(DEP_PATHS),$(shell echo "remove_$(path)"))

#
# Backups
#

.PHONY: backup
backup: backup-tmux-plugins backup-zplug

.PHONY: backup-tmux-plugins
backup-tmux-plugins: \
	tmux/tmux-plugins-$(shell date "+%Y-%m-%d").tar.bz2

.PHONY: backup-zplug
backup-zplug: \
	zsh/zplug-$(shell date "+%Y-%m-%d").tar.bz2

tmux/tmux-plugins-%.tar.bz2: tmux/plugins
	cd tmux && tar -cjf "$(shell basename "$@")" plugins

zsh/zplug-%.tar.bz2: zsh/zplug
	cd zsh && tar -cjf "$(shell basename "$@")" zplug

#
# Internals
#

DEP_PATHS =

define dep-file
DEP_PATHS += $(1)
$(1):
	echo "fetching $(1)..."
	mkdir -p "$(shell dirname "$(1)")" && \
		curl -s -L -o "$(1)" "$(2)"

.PHONY: remove_$(1)
remove_$(1):
	( test -f "$(1)" && rm "$(1)" && echo "removed $(1)" ) || exit 0

.PHONY: update_$(1)
update_$(1): remove_$(1) $(1)
endef

#
# Specify Dependencies
#

$(eval $(call dep-file,zsh/completion/_docker-compose,https://github.com/docker/compose/raw/master/contrib/completion/zsh/_docker-compose))
