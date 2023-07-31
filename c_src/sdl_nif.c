#include <SDL2/SDL.h>
#include <SDL2/SDL_error.h>
#include <erl_nif.h>
#include <stdint.h>

#define SDL_ERROR_TUPLE                                                        \
  enif_make_tuple2(env, atom_error,                                            \
                   enif_make_string(env, SDL_GetError(), ERL_NIF_UTF8))

ERL_NIF_TERM atom_error;
ERL_NIF_TERM atom_ok;
/* ERL_NIF_TERM atom_nil; */

// NOTE: init atoms and resource types in here.
static int load(ErlNifEnv *env, void **priv_data, ERL_NIF_TERM load_info) {
  atom_error = enif_make_atom(env, "error");
  atom_ok = enif_make_atom(env, "ok");
  /* atom_nil = enif_make_atom(env, "nil"); */

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

static ERL_NIF_TERM sdl_quit_nif(ErlNifEnv *env, int argc,
                                 const ERL_NIF_TERM argv[]) {
  SDL_Quit();

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

static ErlNifFunc funcs[] = {
    {"sdl_init_nif", 1, sdl_init_nif},
    {"sdl_init_sub_system_nif", 1, sdl_init_sub_system_nif},
    {"sdl_quit_nif", 0, sdl_quit_nif},
    {"sdl_quit_sub_system_nif", 1, sdl_quit_sub_system_nif},
    {"sdl_was_init_nif", 1, sdl_was_init_nif},
};

ERL_NIF_INIT(Elixir.Sdl, funcs, load, NULL, NULL, NULL)
