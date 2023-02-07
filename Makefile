SRC := $(shell find fennel/src -name '*.fnl')
SRC_PLUGIN := $(shell find fennel/plugin -name '*.fnl')

OUT := $(patsubst fennel/src/%.fnl,lua/%.lua,${SRC})
OUT_PLUGIN := $(patsubst fennel/%.fnl,%.lua,${SRC_PLUGIN})

luaGlobals := vim,unpack

all: $(OUT) $(OUT_PLUGIN)

lua/%.lua: fennel/src/%.fnl
	@mkdir -p $(@D)
	fennel --globals $(luaGlobals) --correlate --compile $< > $@

plugin/%.lua: fennel/plugin/%.fnl
	@mkdir -p $(@D)
	fennel --globals $(luaGlobals) --correlate --compile $< > $@

format: $(SRC)
	fnlfmt --fix $<

clean:
	rm -rf lua plugin

.PHONY: all format clean
