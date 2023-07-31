CC = gcc
CFLAGS = -I/usr/include/SDL2 -I/usr/lib/erlang/usr/include -I$(HOME)/.asdf/installs/erlang/26.0.1/usr/include/ -D_REENTRANT -L/usr/lib -lSDL2 -lSDL2_image
LDFLAGS = -shared -fPIC
nif_libs = sdl_nif.so

all: $(nif_libs)

sdl_nif.so: sdl_nif.c
	$(CC) $(LDFLAGS) $< $(CFLAGS) -o $@

clean:
	rm -rf $(nif_libs)

.PHONY: all clean
