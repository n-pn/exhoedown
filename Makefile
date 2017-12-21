MIX = mix
CFLAGS = -g -O3 -pedantic -Wall -Wextra -Wno-unused-parameter

ERLANG_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
CFLAGS += -I$(ERLANG_PATH)

ifeq ($(wildcard deps/hoedown),)
	HOEDOWN_PATH = ../hoedown
else
	HOEDOWN_PATH = deps/hoedown
endif

CFLAGS += -I$(HOEDOWN_PATH)/src

ifneq ($(OS),Windows_NT)
	CFLAGS += -fPIC

	ifeq ($(shell uname),Darwin)
		LDFLAGS += -dynamiclib -undefined dynamic_lookup
	endif
endif

.PHONY: all exhoedown clean

all: exhoedown

exhoedown:
	$(MIX) compile

priv/exhoedown.so: lib/exhoedown.c
	$(MAKE) -C $(HOEDOWN_PATH) libhoedown.a
	$(CC) $(CFLAGS) -shared $(LDFLAGS) -o $@ lib/exhoedown.c $(HOEDOWN_PATH)/libhoedown.a

clean:
	$(MIX) clean
	$(MAKE) -C $(HOEDOWN_PATH) clean
	$(RM) priv/exhoedown.so
