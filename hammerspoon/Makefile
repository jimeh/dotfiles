.SILENT:

.PHONY: install update clean

#
# Default tasks
#

install:
	$(MAKE) $(DEP_PATHS)

update:
	$(MAKE) $(foreach path,$(DEP_PATHS),update_$(path))

clean:
	$(MAKE) $(foreach path,$(DEP_PATHS),remove_$(path))


#
# Internals
#

DEP_PATHS =

define dep-file
DEP_PATHS += $(1)
$(1):
	echo "fetching $(1)..." && \
		curl -s -L -o $(1) "$(2)" && \
		( test -f "$(1).patch" && patch -p0 < "$(1).patch" ) || exit 0

.PHONY: remove_$(1)
remove_$(1):
	( test -f "$(1)" && rm "$(1)" && echo "removed $(1)" ) || exit 0

.PHONY: update_$(1)
update_$(1): remove_$(1) $(1)
endef

define dep-spoon
DEP_PATHS += Spoons/$(1).spoon

Spoons/$(1).spoon:
	echo "fetching Spoons/$(1).spoon..." && \
		curl -s -L -o "Spoons/$(1).spoon.zip" \
			"https://github.com/Hammerspoon/Spoons/raw/master/Spoons/$(1).spoon.zip" && \
		unzip -d Spoons "Spoons/$(1).spoon.zip" && \
		rm "Spoons/$(1).spoon.zip"
	$(MAKE) patch_Spoons/$(1).spoon

.PHONY: patch_Spoons/$(1).spoon
patch_Spoons/$(1).spoon:
	patch_dir="Spoons/_patches/$(1)"; \
	spoon_dir="Spoons/$(1).spoon"; \
	repo_root=$$$$(git rev-parse --show-toplevel); \
	repo_spoon_dir="hammerspoon/$$$${spoon_dir}"; \
	if test ! -d "$$$${spoon_dir}"; then \
		echo "skipping $$$${spoon_dir} patches (missing spoon dir)"; \
		exit 0; \
	fi; \
	patch_files=$$$$(find "$$$${patch_dir}" -type f -name '*.patch' \
		2>/dev/null \
		| LC_ALL=C sort); \
	if test -z "$$$${patch_files}"; then \
		exit 0; \
	fi; \
	for patch_file in $$$${patch_files}; do \
		repo_patch_file="hammerspoon/$$$${patch_file}"; \
		if (cd "$$$${repo_root}" && \
			git apply --reverse --check \
				--directory="$$$${repo_spoon_dir}" \
				-p1 "$$$${repo_patch_file}" \
			>/dev/null 2>&1); then \
			echo \
				"skipping $$$${patch_file} for $$$${spoon_dir}" \
				"(already applied)"; \
		elif (cd "$$$${repo_root}" && \
			git apply --check \
				--directory="$$$${repo_spoon_dir}" \
				-p1 "$$$${repo_patch_file}" \
			>/dev/null 2>&1); then \
			echo "applying $$$${patch_file} to $$$${spoon_dir}"; \
			patch -f -s -d "$$$${spoon_dir}" -p1 < \
				"$$$${patch_file}" || \
				exit 1; \
		else \
			echo \
				"failed to apply $$$${patch_file} to $$$${spoon_dir}" \
				>&2; \
			exit 1; \
		fi; \
	done

.PHONY: remove_Spoons/$(1).spoon
remove_Spoons/$(1).spoon:
	( \
		test -d "Spoons/$(1).spoon" && \
		echo "removing Spoons/$(1).spoon" && \
		rm -rf "Spoons/$(1).spoon" \
	) || exit 0

.PHONY: update_Spoons/$(1).spoon
update_Spoons/$(1).spoon: \
	remove_Spoons/$(1).spoon \
	Spoons/$(1).spoon
endef


#
# Specify Dependencies
#

$(eval $(call dep-file,inspect.lua,"https://github.com/kikito/inspect.lua/raw/v3.1.0/inspect.lua"))
$(eval $(call dep-spoon,HeadphoneAutoPause,"https://github.com/Hammerspoon/Spoons/raw/master/Spoons/HeadphoneAutoPause.spoon.zip"))
$(eval $(call dep-spoon,RoundedCorners,"https://github.com/Hammerspoon/Spoons/raw/master/Spoons/RoundedCorners.spoon.zip"))
$(eval $(call dep-spoon,URLDispatcher,"https://github.com/Hammerspoon/Spoons/raw/master/Spoons/URLDispatcher.spoon.zip"))
