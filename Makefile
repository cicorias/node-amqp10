REPORTER ?= spec
TESTS = $(shell find ./test/* -name "test_*.js")
NPM_BIN = ./node_modules/.bin

jshint:
	$(NPM_BIN)/jshint lib test tools

fixjsstyle:
	fixjsstyle -r lib -r test --strict --jslint_error=all

coverage:
	make jshint && $(NPM_BIN)/istanbul cover $(NPM_BIN)/_mocha --report lcovonly -- -t 10000 --ui tdd $(TESTS); \

codeclimate-send:
	CODECLIMATE_REPO_TOKEN=b33b8273d40cd973eaa72e274445544847dc4ed74447118765176eae6dd722cb codeclimate < coverage/lcov.info

test:
	@if [ "$$GREP" ]; then \
		make jshint && $(NPM_BIN)/mocha --globals setImmediate,clearImmediate --check-leaks --colors -t 10000 --reporter $(REPORTER) -g "$$GREP" $(TESTS); \
	else \
		make jshint && $(NPM_BIN)/mocha --globals setImmediate,clearImmediate --check-leaks --colors -t 10000 --reporter $(REPORTER) $(TESTS); \
	fi

.PHONY: jshint fixjsstyle coverage codeclimate-send test