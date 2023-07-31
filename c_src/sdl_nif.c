#include <SDL2/SDL.h>
#include <SDL2/SDL_error.h>
#include <SDL2/SDL_surface.h>
#include <erl_nif.h>
#include <stdint.h>

#define SDL_ERROR_TUPLE                                                        \
  enif_make_tuple2(env, atom_error,                                            \
                   enif_make_string(env, SDL_GetError(), ERL_NIF_UTF8))

ERL_NIF_TERM atom_error;
ERL_NIF_TERM atom_ok;
ERL_NIF_TERM atom_nil;
ERL_NIF_TERM atom_true;
ERL_NIF_TERM atom_false;
ERL_NIF_TERM atom_flags;
ERL_NIF_TERM atom_format;
ERL_NIF_TERM atom_w;
ERL_NIF_TERM atom_h;
ERL_NIF_TERM atom_h;
ERL_NIF_TERM atom_pitch;
ERL_NIF_TERM atom_pixels;
ERL_NIF_TERM atom_userdata;
ERL_NIF_TERM atom_locked;
ERL_NIF_TERM atom_list_blitmap;
ERL_NIF_TERM atom_clip_rect;
ERL_NIF_TERM atom_map;
ERL_NIF_TERM atom_refcount;
ERL_NIF_TERM atom_ref;
ERL_NIF_TERM sdl_surface_keys[13];

// NOTE: init atoms and resource types in here.
static int load(ErlNifEnv *env, void **priv_data, ERL_NIF_TERM load_info) {
  atom_error = enif_make_atom(env, "error");
  atom_ok = enif_make_atom(env, "ok");
  atom_nil = enif_make_atom(env, "nil");
  atom_true = enif_make_atom(env, "true");
  atom_false = enif_make_atom(env, "false");
  atom_flags = enif_make_atom(env, "flags");
  atom_format = enif_make_atom(env, "format");
  atom_w = enif_make_atom(env, "w");
  atom_h = enif_make_atom(env, "h");
  atom_h = enif_make_atom(env, "h");
  atom_pitch = enif_make_atom(env, "pitch");
  atom_pixels = enif_make_atom(env, "pixels");
  atom_userdata = enif_make_atom(env, "userdata");
  atom_locked = enif_make_atom(env, "locked");
  atom_list_blitmap = enif_make_atom(env, "list_blitmap");
  atom_clip_rect = enif_make_atom(env, "clip_rect");
  atom_map = enif_make_atom(env, "map");
  atom_refcount = enif_make_atom(env, "refcount");
  atom_ref = enif_make_atom(env, "ref");
  sdl_surface_keys[0] = atom_flags;
  sdl_surface_keys[1] = atom_format;
  sdl_surface_keys[2] = atom_w;
  sdl_surface_keys[3] = atom_h; 
  sdl_surface_keys[4] = atom_pitch;
  sdl_surface_keys[5] = atom_pixels;
  sdl_surface_keys[6] = atom_userdata;
  sdl_surface_keys[7] = atom_locked;
  sdl_surface_keys[8] = atom_list_blitmap;
  sdl_surface_keys[9] = atom_clip_rect;
  sdl_surface_keys[10] = atom_map; 
  sdl_surface_keys[11] = atom_refcount;
  sdl_surface_keys[12] = atom_ref;

  return 0;
}

static ERL_NIF_TERM sdl_init_nif(ErlNifEnv *env, int argc,
                                 const ERL_NIF_TERM argv[]) {
  uint32_t flags;

  if (!enif_get_uint(env, argv[0], &flags)) {
    return enif_make_badarg(env);
  }

  if (SDL_Init(flags) != 0)
    return SDL_ERROR_TUPLE;
  return atom_ok;
}

static ERL_NIF_TERM sdl_init_sub_system_nif(ErlNifEnv *env, int argc,
                                            const ERL_NIF_TERM argv[]) {
  uint32_t flags;

  if (!enif_get_uint(env, argv[0], &flags)) {
    return enif_make_badarg(env);
  }

  if (SDL_InitSubSystem(flags) != 0)
    return SDL_ERROR_TUPLE;
  return atom_ok;
}

static ERL_NIF_TERM sdl_quit_sub_system_nif(ErlNifEnv *env, int argc,
                                            const ERL_NIF_TERM argv[]) {
  uint32_t flags;

  if (!enif_get_uint(env, argv[0], &flags)) {
    return enif_make_badarg(env);
  }

  SDL_QuitSubSystem(flags);

  return atom_ok;
}

static ERL_NIF_TERM sdl_was_init_nif(ErlNifEnv *env, int argc,
                                     const ERL_NIF_TERM argv[]) {
  uint32_t flags;

  if (!enif_get_uint(env, argv[0], &flags)) {
    return enif_make_badarg(env);
  }

  uint32_t retval = SDL_WasInit(flags);

  return enif_make_uint(env, retval);
}

static ERL_NIF_TERM sdl_quit_nif(ErlNifEnv *env, int argc,
                                 const ERL_NIF_TERM argv[]) {
  SDL_Quit();

  return atom_ok;
}

static ERL_NIF_TERM sdl_create_rgb_surface_nif(ErlNifEnv *env, int argc,
                                               const ERL_NIF_TERM argv[]) {
  uint32_t flags, Rmask, Gmask, Bmask, Amask;
  int width, height, depth;

  if (!enif_get_uint(env, argv[0], &flags)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_int(env, argv[1], &width)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_int(env, argv[2], &height)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_int(env, argv[3], &depth)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint(env, argv[4], &Rmask)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint(env, argv[5], &Gmask)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint(env, argv[6], &Bmask)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint(env, argv[8], &Amask)) {
    return enif_make_badarg(env);
  }

  SDL_Surface *ref = SDL_CreateRGBSurface(flags, width, height, depth, Rmask,
                                          Gmask, Bmask, Amask);

  ERL_NIF_TERM val_flags = enif_make_uint(env, ref->flags);
  ERL_NIF_TERM val_format = enif_make_uint64(env, (uint64_t)ref->format); // ptr
  ERL_NIF_TERM val_w = enif_make_int(env, ref->w);
  ERL_NIF_TERM val_h = enif_make_int(env, ref->h);
  ERL_NIF_TERM val_pitch = enif_make_int(env, ref->pitch);
  ERL_NIF_TERM val_pixels = enif_make_uint64(env, (uint64_t)ref->pixels); // ptr
  ERL_NIF_TERM val_userdata =
      enif_make_uint64(env, (uint64_t)ref->userdata);        // ptr
  ERL_NIF_TERM val_locked = enif_make_int(env, ref->locked); // ???
  ERL_NIF_TERM val_list_blitmap =
      enif_make_uint64(env, (uint64_t)ref->list_blitmap);              // ptr
  ERL_NIF_TERM val_clip_rect = enif_make_uint64(env, &ref->clip_rect); // ptr
  ERL_NIF_TERM val_map = enif_make_uint64(env, (uint64_t)ref->map);    // ptr
  ERL_NIF_TERM val_refcount = enif_make_int(env, ref->refcount);
  ERL_NIF_TERM val_ref = enif_make_uint64(env, (uint64_t)ref);
  ERL_NIF_TERM values[] = {val_flags,     val_format, val_w,
                           val_h,         val_pitch,  val_pixels,
                           val_userdata,  val_locked, val_list_blitmap,
                           val_clip_rect, val_map,    val_refcount,
                           val_ref};

  ERL_NIF_TERM retval = enif_make_new_map(env);
  enif_make_map_from_arrays(env, sdl_surface_keys, values, 13, &retval);

  return retval;
}

static ERL_NIF_TERM
sdl_create_rgb_surface_with_format_nif(ErlNifEnv *env, int argc,
                                       const ERL_NIF_TERM argv[]) {
  uint32_t flags, format;
  int width, height, depth;

  if (!enif_get_uint(env, argv[0], &flags)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_int(env, argv[1], &width)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_int(env, argv[2], &height)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_int(env, argv[3], &depth)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint(env, argv[4], &format)) {
    return enif_make_badarg(env);
  }

  SDL_Surface *ref =
      SDL_CreateRGBSurfaceWithFormat(flags, width, height, depth, format);

  ERL_NIF_TERM val_flags = enif_make_uint(env, ref->flags);
  ERL_NIF_TERM val_format = enif_make_uint64(env, (uint64_t)ref->format); // ptr
  ERL_NIF_TERM val_w = enif_make_int(env, ref->w);
  ERL_NIF_TERM val_h = enif_make_int(env, ref->h);
  ERL_NIF_TERM val_pitch = enif_make_int(env, ref->pitch);
  ERL_NIF_TERM val_pixels = enif_make_uint64(env, (uint64_t)ref->pixels); // ptr
  ERL_NIF_TERM val_userdata =
      enif_make_uint64(env, (uint64_t)ref->userdata);        // ptr
  ERL_NIF_TERM val_locked = enif_make_int(env, ref->locked); // ???
  ERL_NIF_TERM val_list_blitmap =
      enif_make_uint64(env, (uint64_t)ref->list_blitmap);              // ptr
  ERL_NIF_TERM val_clip_rect = enif_make_uint64(env, &ref->clip_rect); // ptr
  ERL_NIF_TERM val_map = enif_make_uint64(env, (uint64_t)ref->map);    // ptr
  ERL_NIF_TERM val_refcount = enif_make_int(env, ref->refcount);
  ERL_NIF_TERM val_ref = enif_make_uint64(env, (uint64_t)ref);
  ERL_NIF_TERM values[] = {val_flags,     val_format, val_w,
                           val_h,         val_pitch,  val_pixels,
                           val_userdata,  val_locked, val_list_blitmap,
                           val_clip_rect, val_map,    val_refcount,
                           val_ref};

  ERL_NIF_TERM retval = enif_make_new_map(env);
  enif_make_map_from_arrays(env, sdl_surface_keys, values, 13, &retval);

  return retval;
}

static ErlNifFunc funcs[] = {
    {"sdl_init_nif", 1, sdl_init_nif},
    {"sdl_init_sub_system_nif", 1, sdl_init_sub_system_nif},
    {"sdl_quit_sub_system_nif", 1, sdl_quit_sub_system_nif},
    {"sdl_was_init_nif", 1, sdl_was_init_nif},
    {"sdl_quit_nif", 0, sdl_quit_nif},
    {"sdl_create_rgb_surface_nif", 8, sdl_create_rgb_surface_nif},
    {"sdl_create_rgb_surface_with_format_nif", 5, sdl_create_rgb_surface_with_format_nif},
};

ERL_NIF_INIT(Elixir.Sdl, funcs, load, NULL, NULL, NULL)
