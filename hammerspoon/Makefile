.SILENT:

install: \
	ext/grid.lua \
	inspect.lua \
	installSpoons \
	hs/_asm/undocumented/spaces
update: \
	update_ext/grid.lua \
	update_inspect.lua \
	updateSpoons \
	update_hs/_asm/undocumented/spaces

#
# Config
#

SPOONS = RoundedCorners HeadphoneAutoPause
INSPECT_VERSION = 3.1.0
SPACES_VERSION = 0.5

SPOONS_DIR = Spoons
SPOON_PATHS = $(foreach s,$(SPOONS),$(shell echo $(SPOONS_DIR)/$(s).spoon))


#
# Spoons
#

.PHONY: installSpoons
installSpoons: $(SPOON_PATHS)

.PHONY: removeSpoons
removeSpoons:
	$(foreach dir,$(SPOON_PATHS),(test -d "$(dir)" && echo "removing $(dir)" && rm -rf "$(dir)") || exit 0;)

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
	( test -f "$@.patch" && patch -p0 < "$@.patch" ) || exit 0

.PHONY: remove_ext/grid.lua
remove_ext/grid.lua:
	( \
		test -f "ext/grid.lua" && rm "ext/grid.lua" && \
		echo "removed ext/grid.lua" \
	) || exit 0

.PHONY: update_ext/grid.lua
update_ext/grid.lua: remove_ext/grid.lua ext/grid.lua


#
# Spaces module
#

hs/_asm/undocumented/spaces:
	echo "fetching $@..." && \
		curl -s -L -o "spaces-v$(SPACES_VERSION).zip" \
			"https://github.com/asmagill/hs._asm.undocumented.spaces/releases/download/v0.5/spaces-v$(SPACES_VERSION).tar.gz" && \
		tar -xvzf "spaces-v$(SPACES_VERSION).zip" && \
		rm "spaces-v$(SPACES_VERSION).zip"

.PHONY: remove_hs/_asm/undocumented/spaces
remove_hs/_asm/undocumented/spaces:
	( \
		test -d "hs/_asm/undocumented/spaces" && \
		rm -rf "hs/_asm/undocumented/spaces" && \
		echo "removed hs/_asm/undocumented/spaces" \
	) || exit 0

.PHONY: update_hs/_asm/undocumented/spaces
update_hs/_asm/undocumented/spaces: \
	remove_hs/_asm/undocumented/spaces \
	hs/_asm/undocumented/spaces


#
# inspect.lua - useful for debugging
#

inspect.lua:
	echo "fetching $@..." && \
	curl -s -L -o "$@" \
		"https://raw.githubusercontent.com/kikito/inspect.lua/v$(INSPECT_VERSION)/inspect.lua"

.PHONY: remove_inspect.lua
remove_inspect.lua:
	( \
		test -f "inspect.lua" && rm "inspect.lua" && \
		echo "removed inspect.lua" \
	) || exit 0

.PHONY: update_inspect.lua
update_inspect.lua: remove_inspect.lua inspect.lua
