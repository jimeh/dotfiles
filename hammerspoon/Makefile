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
		rm "Spoons/$(1).spoon.zip" && \
		( \
			test -f "Spoons/$(1).spoon.patch" && \
			patch -p0 < "Spoons/$(1).spoon.patch" \
		) || exit 0

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
$(eval $(call dep-spoon,RoundedCorners,"https://github.com/Hammerspoon/Spoons/raw/master/Spoons/RoundedCorners.spoon.zip"))
$(eval $(call dep-spoon,HeadphoneAutoPause,"https://github.com/Hammerspoon/Spoons/raw/master/Spoons/HeadphoneAutoPause.spoon.zip"))
$(eval $(call dep-spoon,PushToTalk,"https://github.com/Hammerspoon/Spoons/raw/master/Spoons/PushToTalk.spoon.zip"))
