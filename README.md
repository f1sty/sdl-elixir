# Sdl

[SDL2](https://www.libsdl.org/) development library wrapper for Elixir empowered by
[NIFs](https://www.erlang.org/doc/man/erl_nif.html)


## Details

This library is the second iteration of my [sdl bindings](https://github.com/f1sty/sexdl).

## Run examples

To compile NIFs and launch example programs, run:

```bash
$ mix do deps.get, compile
$ iex -S mix
```

followed by:

```elixir
iex> Sdl.Examples.Image.run("/full/path/to/a/picture.png")
```

or:

```elixir
iex> Sdl.Examples.Simple.run()
```

Window with an image should appear in the first case. In the second one you should see regular
window with a pleasant bluish colour. If you ran second example, you also can close the window by
pressing `q`.

## Implemented functions (so far):

name, arity **notes**

- `SDL_Init`, 1
- `SDL_InitSubSystem`, 1
- `SDL_QuitSubSystem`, 1
- `SDL_WasInit`, 1
- `SDL_Quit`, 0
- `SDL_CreateRgbSurface`, 8
- `SDL_CreateRgbSurfaceWithFormat`, 5
- `SDL_CreateRgbSurfaceFrom`, 9
- `SDL_CreateRgbSurfaceWithFormatFrom`, 6
- `SDL_FreeSurface`, 1
- `SDL_SetSurfacePalette`, 2
- `SDL_LockSurface`, 1
- `SDL_UnlockSurface`, 1
- `SDL_LoadBmpRW`, 2
- `SDL_LoadBmp`, 1
- `SDL_SaveBmpRW`, 3
- `SDL_SaveBmp`, 2
- `SDL_SetSurfaceRLE`, 2
- `SDL_HasSurfaceRLE`, 1
- `SDL_SetColorKey`, 3
- `SDL_HasColorKey`, 1
- `SDL_GetColorKey`, 1 **instead of 2**
- `SDL_SetSurfaceColorMod`, 4
- `SDL_GetSurfaceColorMod`, 1 **instead of 4**
- `SDL_SetSurfaceAlphaMod`, 2
- `SDL_GetSurfaceAlphaMod`, 1 **instead of 2**
- `SDL_SetSurfaceBlendMode`, 2
- `SDL_GetSurfaceBlendMode`, 1 **instead of 2**
- `SDL_UpperBlit`, 4
- `SDL_GetVideoDriver`, 1
- `SDL_VideoInit`, 1
- `SDL_CreateWindow`, 6
- `SDL_GetWindowSurface`, 1
- `SDL_DestroyWindow`, 1
- `SDL_CreateRenderer`, 3
- `SDL_CreateTextureFromSurface`, 2
- `IMG_Load`, 1
- `SDL_QueryTexture`, 1 **instead of 5**
- `SDL_RenderClear`, 1
- `SDL_RenderCopy`, 4
- `SDL_RenderPresent`, 1
- `SDL_PollEvent`, 0 **instead of 1**
- `SDL_DestroyTexture`, 1
- `SDL_DestroyRenderer`, 1
- `SDL_SetRenderDrawColor`, 5
- `SDL_Delay`, 1
