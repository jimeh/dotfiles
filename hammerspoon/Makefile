.SILENT:

install: ext/grid.lua installSpoons
update: update_ext/grid.lua updateSpoons

#
# Spoons
#

SPOONS = RoundedCorners \
	HeadphoneAutoPause
SPOONS_DIR = Spoons
SPOON_PATHS = $(foreach s,$(SPOONS),$(shell echo $(SPOONS_DIR)/$(s).spoon))

.PHONY: installSpoons
installSpoons: $(SPOON_PATHS)

.PHONY: removeSpoons
removeSpoons:
	$(foreach dir,$(SPOON_PATHS),(test -d "$(dir)" && echo "removing $(dir)" && rm -rf "$(dir)") || exit 0;)
	# $(foreach dir,$(SPOON_PATHS),echo "removing $(dir)";)

.PHONY: updateSpoons
updateSpoons: removeSpoons installSpoons

$(SPOONS_DIR)/%.spoon:
	echo "fetching $@..." && \
		curl -s -L -o "$@.zip" \
			"https://github.com/Hammerspoon/Spoons/raw/master/$@.zip" && \
		unzip -d $(SPOONS_DIR) "$@.zip" && \
		rm "$@.zip" && \
		( test -f "$@.patch" && patch -p0 < "$@.patch" ) || exit 0


#
# Core extentions and patching
#

ext/grid.lua:
	echo "fetching $@..." && \
		curl -s -L -o $@ \
			https://raw.githubusercontent.com/Hammerspoon/hammerspoon/master/extensions/grid/init.lua && \
		make patch_$@

.PHONY: patch_ext/grid.lua
patch_ext/grid.lua:
	echo "patching ext/grid.lua..." && \
		patch -p0 < ext/grid.lua.patch

.PHONY: remove_ext/grid.lua
remove_ext/grid.lua:
	( \
		test -f "ext/grid.lua" && rm "ext/grid.lua" && \
		echo "removed ext/grid.lua" \
	) || exit 0

.PHONY: update_ext/grid.lua
update_ext/grid.lua: remove_ext/grid.lua ext/grid.lua
