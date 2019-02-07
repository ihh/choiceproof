NODE_MODULES = node_modules
PEGJS = $(NODE_MODULES)/pegjs/bin/pegjs

all: $(subst .pegjs,.js,$(wildcard src/*.pegjs))

src/%.js: src/%.pegjs
	$(PEGJS) $< >$@
