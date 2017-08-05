.SILENT:

ext/grid.lua:
	echo "fetching ext/grid.lua..." && \
		curl -s -L -o ext/grid.lua \
		https://raw.githubusercontent.com/Hammerspoon/hammerspoon/master/extensions/grid/init.lua && \
		make patch_ext/grid.lua

.PHONY: patch_ext/grid.lua
patch_ext/grid.lua:
	echo "patching ext/grid.lua..." && \
		patch -p0 < ext/grid.patch

.PHONY: remove_ext/grid.lua
remove_ext/grid.lua:
	( \
		test -f "ext/grid.lua" && rm "ext/grid.lua" && \
		echo "removed ext/grid.lua" \
	) || exit 0

.PHONY: update_ext/grid.lua
update_ext/grid.lua: remove_ext/grid.lua ext/grid.lua
