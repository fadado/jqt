########################################################################
# tools.make
#
# Miscelaneous tools.
#
# Defined targets:
# 	list

########################################################################
# Show all targets.
########################################################################

.PHONY: list

# Warning: `make list` can build several phases.
list:
	@echo 'Usage: make TARGET [parameter=value...]'
	@echo 'Targets:';					\
	$(MAKE) --print-data-base --just-print 2>&1		\
	| grep -v '^[mM]akefile'				\
	| awk '/^[^ \t.%][-A-Za-z0-9_.]*:/ { print $$1 }'	\
	| sort --unique						\
	| sed 's/:\+$$//'					\
	| pr --omit-pagination --indent=4 --width=80 --columns=4

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
