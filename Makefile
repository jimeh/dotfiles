.PHONY: backup-elpa
backup-zplug-cache:
	cd shell/zsh \
		&& tar -cjf zplug-cache-$(shell date "+%Y-%m-%d").tar.bz2 zplug-cache
