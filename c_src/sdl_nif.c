#include <SDL2/SDL.h>
#include <SDL2/SDL_error.h>
#include <SDL2/SDL_surface.h>
#include <erl_nif.h>
#include <stdint.h>

#define SDL_ERROR_TUPLE                                                        \
  enif_make_tuple2(env, atom_error,                                            \
                   enif_make_string(env, SDL_GetError(), ERL_NIF_UTF8))

#define LEN(x) (sizeof(x) / sizeof(x[0]))

ERL_NIF_TERM atom_error;
ERL_NIF_TERM atom_ok;
ERL_NIF_TERM atom_nil;
ERL_NIF_TERM atom_true;
ERL_NIF_TERM atom_false;
ERL_NIF_TERM atom_flags;
ERL_NIF_TERM atom_format;
ERL_NIF_TERM atom_x;
ERL_NIF_TERM atom_y;
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
ERL_NIF_TERM atom_palette;
ERL_NIF_TERM atom_bits_per_pixel;
ERL_NIF_TERM atom_bytes_per_pixel;
ERL_NIF_TERM atom_padding;
ERL_NIF_TERM atom_palette;
ERL_NIF_TERM atom_r_mask;
ERL_NIF_TERM atom_g_mask;
ERL_NIF_TERM atom_b_mask;
ERL_NIF_TERM atom_a_mask;
ERL_NIF_TERM atom_r_loss;
ERL_NIF_TERM atom_g_loss;
ERL_NIF_TERM atom_b_loss;
ERL_NIF_TERM atom_a_loss;
ERL_NIF_TERM atom_r_shift;
ERL_NIF_TERM atom_g_shift;
ERL_NIF_TERM atom_b_shift;
ERL_NIF_TERM atom_a_shift;
ERL_NIF_TERM atom_next;
ERL_NIF_TERM atom_ncolors;
ERL_NIF_TERM atom_colors;
ERL_NIF_TERM atom_version;
ERL_NIF_TERM atom_r;
ERL_NIF_TERM atom_g;
ERL_NIF_TERM atom_b;
ERL_NIF_TERM atom_a;

ERL_NIF_TERM sdl_surface_keys[13];
ERL_NIF_TERM sdl_rect_keys[5];
ERL_NIF_TERM sdl_pixel_format_keys[20];
ERL_NIF_TERM sdl_palette_keys[5];
ERL_NIF_TERM sdl_color_keys[5];

static ERL_NIF_TERM sdl_surface_map(ErlNifEnv *env, SDL_Surface *ref) {
  ERL_NIF_TERM val_format = atom_nil;
  ERL_NIF_TERM val_format_palette = atom_nil;
  ERL_NIF_TERM val_format_palette_colors = atom_nil;
  ERL_NIF_TERM val_clip_rect = atom_nil;
  ERL_NIF_TERM val_flags = enif_make_uint(env, ref->flags);
  if (ref->format != NULL) {
    ERL_NIF_TERM val_format_format = enif_make_uint(env, ref->format->format);
    if (ref->format->palette != NULL) {
      ERL_NIF_TERM val_format_palette_ncolors =
          enif_make_int(env, ref->format->palette->ncolors);
      if (ref->format->palette->colors != NULL) {
        ERL_NIF_TERM val_format_palette_colors_r =
            enif_make_uint(env, ref->format->palette->colors->r);
        ERL_NIF_TERM val_format_palette_colors_g =
            enif_make_uint(env, ref->format->palette->colors->g);
        ERL_NIF_TERM val_format_palette_colors_b =
            enif_make_uint(env, ref->format->palette->colors->b);
        ERL_NIF_TERM val_format_palette_colors_a =
            enif_make_uint(env, ref->format->palette->colors->a);
        ERL_NIF_TERM val_format_palette_colors_ref =
            enif_make_uint64(env, (uint64_t)ref->format->palette->colors);
        ERL_NIF_TERM val_format_palette_colors_values[] = {
            val_format_palette_colors_r, val_format_palette_colors_g,
            val_format_palette_colors_b, val_format_palette_colors_a,
            val_format_palette_colors_ref};
        /* ERL_NIF_TERM val_format_palette_colors = enif_make_new_map(env); */
        val_format_palette_colors = enif_make_new_map(env);
        enif_make_map_from_arrays(
            env, sdl_color_keys, val_format_palette_colors_values,
            LEN(val_format_palette_colors_values), &val_format_palette_colors);
      }
      ERL_NIF_TERM val_format_palette_version =
          enif_make_uint(env, ref->format->palette->version);
      ERL_NIF_TERM val_format_palette_refcount =
          enif_make_uint(env, ref->format->palette->refcount);
      ERL_NIF_TERM val_format_palette_ref =
          enif_make_uint64(env, (uint64_t)ref->format->palette);
      ERL_NIF_TERM val_format_palette_values[] = {
          val_format_palette_ncolors, val_format_palette_colors,
          val_format_palette_version, val_format_palette_refcount,
          val_format_palette_ref};
      /* ERL_NIF_TERM val_format_palette = enif_make_new_map(env); */
      val_format_palette = enif_make_new_map(env);
      enif_make_map_from_arrays(
          env, sdl_palette_keys, val_format_palette_values,
          LEN(val_format_palette_values), &val_format_palette);
    }
    ERL_NIF_TERM val_format_bits_per_pixel =
        enif_make_uint(env, ref->format->BitsPerPixel);
    ERL_NIF_TERM val_format_bytes_per_pixel =
        enif_make_uint(env, ref->format->BytesPerPixel);
    ERL_NIF_TERM padding[2];
    for (int i = 0; i < 2; i++) {
      ERL_NIF_TERM padding_i = enif_make_int(env, ref->format->padding[i]);
      padding[i] = padding_i;
    }
    ERL_NIF_TERM val_format_padding =
        enif_make_list_from_array(env, padding, 2);
    ERL_NIF_TERM val_format_r_mask = enif_make_uint(env, ref->format->Rmask);
    ERL_NIF_TERM val_format_g_mask = enif_make_uint(env, ref->format->Gmask);
    ERL_NIF_TERM val_format_b_mask = enif_make_uint(env, ref->format->Bmask);
    ERL_NIF_TERM val_format_a_mask = enif_make_uint(env, ref->format->Amask);
    ERL_NIF_TERM val_format_r_loss = enif_make_uint(env, ref->format->Rloss);
    ERL_NIF_TERM val_format_g_loss = enif_make_uint(env, ref->format->Gloss);
    ERL_NIF_TERM val_format_b_loss = enif_make_uint(env, ref->format->Bloss);
    ERL_NIF_TERM val_format_a_loss = enif_make_uint(env, ref->format->Aloss);
    ERL_NIF_TERM val_format_r_shift = enif_make_uint(env, ref->format->Rshift);
    ERL_NIF_TERM val_format_g_shift = enif_make_uint(env, ref->format->Gshift);
    ERL_NIF_TERM val_format_b_shift = enif_make_uint(env, ref->format->Bshift);
    ERL_NIF_TERM val_format_a_shift = enif_make_uint(env, ref->format->Ashift);
    ERL_NIF_TERM val_format_refcount =
        enif_make_uint(env, ref->format->refcount);
    ERL_NIF_TERM val_format_next =
        enif_make_uint64(env, (uint64_t)ref->format->next);
    ERL_NIF_TERM val_format_ref = enif_make_uint64(env, (uint64_t)ref->format);
    ERL_NIF_TERM val_format_values[] = {
        val_format_format,         val_format_palette,
        val_format_bits_per_pixel, val_format_bytes_per_pixel,
        val_format_padding,        val_format_r_mask,
        val_format_g_mask,         val_format_b_mask,
        val_format_a_mask,         val_format_r_loss,
        val_format_g_loss,         val_format_b_loss,
        val_format_a_loss,         val_format_r_shift,
        val_format_g_shift,        val_format_b_shift,
        val_format_a_shift,        val_format_refcount,
        val_format_next,           val_format_ref};
    /* ERL_NIF_TERM val_format = enif_make_new_map(env); */
    val_format = enif_make_new_map(env);
    enif_make_map_from_arrays(env, sdl_pixel_format_keys, val_format_values,
                              LEN(val_format_values), &val_format);
  }
  ERL_NIF_TERM val_w = enif_make_int(env, ref->w);
  ERL_NIF_TERM val_h = enif_make_int(env, ref->h);
  ERL_NIF_TERM val_pitch = enif_make_int(env, ref->pitch);
  ERL_NIF_TERM val_pixels = enif_make_uint64(env, (uint64_t)ref->pixels); // ptr
  ERL_NIF_TERM val_userdata =
      enif_make_uint64(env, (uint64_t)ref->userdata);        // ptr
  ERL_NIF_TERM val_locked = enif_make_int(env, ref->locked); // ???
  ERL_NIF_TERM val_list_blitmap =
      enif_make_uint64(env, (uint64_t)ref->list_blitmap); // ptr
  if (&ref->clip_rect != NULL) {
    ERL_NIF_TERM val_clip_rect_x = enif_make_int(env, ref->clip_rect.x);
    ERL_NIF_TERM val_clip_rect_y = enif_make_int(env, ref->clip_rect.y);
    ERL_NIF_TERM val_clip_rect_w = enif_make_int(env, ref->clip_rect.w);
    ERL_NIF_TERM val_clip_rect_h = enif_make_int(env, ref->clip_rect.h);
    ERL_NIF_TERM val_clip_rect_ref =
        enif_make_uint64(env, (uint64_t)&ref->clip_rect); // ptr
    ERL_NIF_TERM val_clip_rect_values[] = {val_clip_rect_x, val_clip_rect_y,
                                           val_clip_rect_w, val_clip_rect_h,
                                           val_clip_rect_ref};
    /* ERL_NIF_TERM val_clip_rect = enif_make_new_map(env); */
    val_clip_rect = enif_make_new_map(env);
    enif_make_map_from_arrays(env, sdl_rect_keys, val_clip_rect_values,
                              LEN(val_clip_rect_values), &val_clip_rect);
  }
  ERL_NIF_TERM val_map = enif_make_uint64(env, (uint64_t)ref->map); // ptr
  ERL_NIF_TERM val_refcount = enif_make_int(env, ref->refcount);
  ERL_NIF_TERM val_ref = enif_make_uint64(env, (uint64_t)ref);
  ERL_NIF_TERM values[] = {val_flags,     val_format, val_w,
                           val_h,         val_pitch,  val_pixels,
                           val_userdata,  val_locked, val_list_blitmap,
                           val_clip_rect, val_map,    val_refcount,
                           val_ref};

  ERL_NIF_TERM retval = enif_make_new_map(env);
  enif_make_map_from_arrays(env, sdl_surface_keys, values, LEN(values),
                            &retval);

  return retval;
}

// NOTE: init atoms and resource types in here.
static int load(ErlNifEnv *env, void **priv_data, ERL_NIF_TERM load_info) {
  atom_error = enif_make_atom(env, "error");
  atom_ok = enif_make_atom(env, "ok");
  atom_nil = enif_make_atom(env, "nil");
  atom_true = enif_make_atom(env, "true");
  atom_false = enif_make_atom(env, "false");
  atom_flags = enif_make_atom(env, "flags");
  atom_format = enif_make_atom(env, "format");
  atom_x = enif_make_atom(env, "x");
  atom_y = enif_make_atom(env, "y");
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
  atom_palette = enif_make_atom(env, "palette");
  atom_bits_per_pixel = enif_make_atom(env, "bits_per_pixel");
  atom_bytes_per_pixel = enif_make_atom(env, "bytes_per_pixel");
  atom_padding = enif_make_atom(env, "padding");
  atom_palette = enif_make_atom(env, "palette");
  atom_r_mask = enif_make_atom(env, "r_mask");
  atom_g_mask = enif_make_atom(env, "g_mask");
  atom_b_mask = enif_make_atom(env, "b_mask");
  atom_a_mask = enif_make_atom(env, "a_mask");
  atom_r_loss = enif_make_atom(env, "r_loss");
  atom_g_loss = enif_make_atom(env, "g_loss");
  atom_b_loss = enif_make_atom(env, "b_loss");
  atom_a_loss = enif_make_atom(env, "a_loss");
  atom_r_shift = enif_make_atom(env, "r_shift");
  atom_g_shift = enif_make_atom(env, "g_shift");
  atom_b_shift = enif_make_atom(env, "b_shift");
  atom_a_shift = enif_make_atom(env, "a_shift");
  atom_next = enif_make_atom(env, "next");
  atom_ncolors = enif_make_atom(env, "ncolors");
  atom_colors = enif_make_atom(env, "colors");
  atom_version = enif_make_atom(env, "version");
  atom_r = enif_make_atom(env, "r");
  atom_g = enif_make_atom(env, "g");
  atom_b = enif_make_atom(env, "b");
  atom_a = enif_make_atom(env, "a");

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
  sdl_rect_keys[0] = atom_x;
  sdl_rect_keys[1] = atom_y;
  sdl_rect_keys[2] = atom_w;
  sdl_rect_keys[3] = atom_h;
  sdl_rect_keys[4] = atom_ref;
  sdl_pixel_format_keys[0] = atom_format;
  sdl_pixel_format_keys[1] = atom_palette;
  sdl_pixel_format_keys[2] = atom_bits_per_pixel;
  sdl_pixel_format_keys[3] = atom_bytes_per_pixel;
  sdl_pixel_format_keys[4] = atom_padding;
  sdl_pixel_format_keys[5] = atom_r_mask;
  sdl_pixel_format_keys[6] = atom_g_mask;
  sdl_pixel_format_keys[7] = atom_b_mask;
  sdl_pixel_format_keys[8] = atom_a_mask;
  sdl_pixel_format_keys[9] = atom_r_loss;
  sdl_pixel_format_keys[10] = atom_g_loss;
  sdl_pixel_format_keys[11] = atom_b_loss;
  sdl_pixel_format_keys[12] = atom_a_loss;
  sdl_pixel_format_keys[13] = atom_r_shift;
  sdl_pixel_format_keys[14] = atom_g_shift;
  sdl_pixel_format_keys[15] = atom_b_shift;
  sdl_pixel_format_keys[16] = atom_a_shift;
  sdl_pixel_format_keys[17] = atom_refcount;
  sdl_pixel_format_keys[18] = atom_next;
  sdl_pixel_format_keys[19] = atom_ref;
  sdl_palette_keys[0] = atom_ncolors;
  sdl_palette_keys[1] = atom_colors;
  sdl_palette_keys[2] = atom_version;
  sdl_palette_keys[3] = atom_refcount;
  sdl_palette_keys[4] = atom_ref;
  sdl_color_keys[0] = atom_r;
  sdl_color_keys[1] = atom_g;
  sdl_color_keys[2] = atom_b;
  sdl_color_keys[3] = atom_a;
  sdl_color_keys[4] = atom_ref;
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

  return sdl_surface_map(env, ref);
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

  return sdl_surface_map(env, ref);
}

static ErlNifFunc funcs[] = {
    {"sdl_init_nif", 1, sdl_init_nif},
    {"sdl_init_sub_system_nif", 1, sdl_init_sub_system_nif},
    {"sdl_quit_sub_system_nif", 1, sdl_quit_sub_system_nif},
    {"sdl_was_init_nif", 1, sdl_was_init_nif},
    {"sdl_quit_nif", 0, sdl_quit_nif},
    {"sdl_create_rgb_surface_nif", 8, sdl_create_rgb_surface_nif},
    {"sdl_create_rgb_surface_with_format_nif", 5,
     sdl_create_rgb_surface_with_format_nif},
};

ERL_NIF_INIT(Elixir.Sdl, funcs, load, NULL, NULL, NULL)
