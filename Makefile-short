sync:
	pass git checkout master 
	pass git fetch --all 
	pass git rebase origin/master 
	pass git push origin master
# $@  The file that is being made right now by this rule (aka the "target")
# $<  The input file (that is, the first prerequisite in the list)
# $^  This is the list of ALL input files, not just the first one.
# $?  All the input files that are newer than the target
# $$  A literal $ character inside of the rules section
# $*  The "stem" part that matched in the rule definition's % bit
# You can also use the special syntax $(@D) and $(@F) to refer to
# just the dir and file portions of $@, respectively.  $(<D) and
result-using-var.txt: source.txt
	@echo "buildling result-using-var.txt using the $$< and $$@ vars"
	cp $< $@
# Also, usually you'd use `$(wildcard src/*.txt)` instead, since
srcfiles := $(shell echo src/{00..99}.txt)

src/%.txt:
	@# First things first, create the dir if it doesn't exist.
	@# Prepend with @ because srsly who cares about dir creation
	@[ -d src ] || mkdir src
	@# then, we just echo some data into the file
	@# The $* expands to the "stem" bit matched by %
	@# So, we get a bunch of files with numeric names, containing their number
	echo $* > $@
# Try running `make src/00.txt` and `make src/01.txt` now.
source: $(srcfiles)
dest/%.txt: src/%.txt
	@[ -d dest ] || mkdir dest
	cp $< $@
destfiles := $(patsubst src/%.txt,dest/%.txt,$(srcfiles))
destination: $(destfiles)
kitty: $(destfiles)
	@# Remember, $< is the input file, but $^ is ALL the input files.
	@# Cat them into the kitty.
	cat $^ > kitty
test: kitty
	@echo "miao" && echo "tests all pass!"

badkitty:
	$(MAKE) kitty # The special var $(MAKE) means "the make currently in use"
	false # <-- this will fail
	echo "should not get here"

.PHONY: source destination clean test badkitty

