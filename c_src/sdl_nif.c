#include <SDL2/SDL.h>
#include <SDL2/SDL_blendmode.h>
#include <SDL2/SDL_error.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_render.h>
#include <SDL2/SDL_rwops.h>
#include <SDL2/SDL_surface.h>
#include <SDL2/SDL_video.h>
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

  if (ref == NULL)
    return SDL_ERROR_TUPLE;

  return enif_make_tuple2(env, atom_ok, sdl_surface_map(env, ref));
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

  if (ref == NULL)
    return SDL_ERROR_TUPLE;

  return enif_make_tuple2(env, atom_ok, sdl_surface_map(env, ref));
}

static ERL_NIF_TERM sdl_create_rgb_surface_from_nif(ErlNifEnv *env, int argc,
                                                    const ERL_NIF_TERM argv[]) {
  uint32_t Rmask, Gmask, Bmask, Amask;
  int width, height, depth, pitch;
  void *pixels = NULL;

  if (!enif_get_uint64(env, argv[0], &pixels)) {
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
  if (!enif_get_int(env, argv[4], &pitch)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint(env, argv[5], &Rmask)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint(env, argv[6], &Gmask)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint(env, argv[7], &Bmask)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint(env, argv[8], &Amask)) {
    return enif_make_badarg(env);
  }

  SDL_Surface *ref = SDL_CreateRGBSurfaceFrom(
      pixels, width, height, depth, pitch, Rmask, Gmask, Bmask, Amask);

  if (ref == NULL)
    return SDL_ERROR_TUPLE;

  return enif_make_tuple2(env, atom_ok, sdl_surface_map(env, ref));
}

static ERL_NIF_TERM
sdl_create_rgb_surface_with_format_from_nif(ErlNifEnv *env, int argc,
                                            const ERL_NIF_TERM argv[]) {
  uint32_t format;
  int width, height, depth, pitch;
  void *pixels = NULL;

  if (!enif_get_uint64(env, argv[0], &pixels)) {
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
  if (!enif_get_int(env, argv[4], &pitch)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint(env, argv[5], &format)) {
    return enif_make_badarg(env);
  }

  SDL_Surface *ref = SDL_CreateRGBSurfaceWithFormatFrom(pixels, width, height,
                                                        depth, pitch, format);

  if (ref == NULL)
    return SDL_ERROR_TUPLE;

  return enif_make_tuple2(env, atom_ok, sdl_surface_map(env, ref));
}

static ERL_NIF_TERM sdl_free_surface_nif(ErlNifEnv *env, int argc,
                                         const ERL_NIF_TERM argv[]) {
  SDL_Surface *ref;
  if (!enif_get_uint64(env, argv[0], &ref)) {
    return enif_make_badarg(env);
  }

  SDL_FreeSurface(ref);

  return atom_ok;
}

static ERL_NIF_TERM sdl_set_surface_palette_nif(ErlNifEnv *env, int argc,
                                                const ERL_NIF_TERM argv[]) {
  SDL_Surface *surface_ref;
  SDL_Palette *palette_ref;
  if (!enif_get_uint64(env, argv[0], &surface_ref)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint64(env, argv[1], &palette_ref)) {
    return enif_make_badarg(env);
  }

  if (SDL_SetSurfacePalette(surface_ref, palette_ref) < 0)
    return SDL_ERROR_TUPLE;

  return enif_make_tuple2(env, atom_ok, sdl_surface_map(env, surface_ref));
}

static ERL_NIF_TERM sdl_lock_surface_nif(ErlNifEnv *env, int argc,
                                         const ERL_NIF_TERM argv[]) {
  SDL_Surface *ref;
  if (!enif_get_uint64(env, argv[0], &ref)) {
    return enif_make_badarg(env);
  }

  if (SDL_LockSurface(ref) < 0)
    return SDL_ERROR_TUPLE;

  return enif_make_tuple2(env, atom_ok, sdl_surface_map(env, ref));
}

static ERL_NIF_TERM sdl_unlock_surface_nif(ErlNifEnv *env, int argc,
                                           const ERL_NIF_TERM argv[]) {
  SDL_Surface *ref;
  if (!enif_get_uint64(env, argv[0], &ref)) {
    return enif_make_badarg(env);
  }

  SDL_UnlockSurface(ref);

  return atom_ok;
}

static ERL_NIF_TERM sdl_load_bmp_rw_nif(ErlNifEnv *env, int argc,
                                        const ERL_NIF_TERM argv[]) {
  SDL_RWops *src;
  int freesrc;

  if (!enif_get_uint64(env, argv[0], &src)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_int(env, argv[1], &freesrc)) {
    return enif_make_badarg(env);
  }

  SDL_Surface *ref = SDL_LoadBMP_RW(src, freesrc);

  if (ref == NULL)
    return SDL_ERROR_TUPLE;

  return enif_make_tuple2(env, atom_ok, sdl_surface_map(env, ref));
}

static ERL_NIF_TERM sdl_load_bmp_nif(ErlNifEnv *env, int argc,
                                     const ERL_NIF_TERM argv[]) {
  char file[256];

  if (!enif_get_string(env, argv[0], file, 256, ERL_NIF_UTF8)) {
    return enif_make_badarg(env);
  }

  SDL_Surface *ref = SDL_LoadBMP_RW(SDL_RWFromFile(file, "rb"), 1);

  if (ref == NULL)
    return SDL_ERROR_TUPLE;

  return enif_make_tuple2(env, atom_ok, sdl_surface_map(env, ref));
}

static ERL_NIF_TERM sdl_save_bmp_rw_nif(ErlNifEnv *env, int argc,
                                        const ERL_NIF_TERM argv[]) {
  SDL_Surface *surface;
  SDL_RWops *dst;
  int freesrc;

  if (!enif_get_uint64(env, argv[0], &surface)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint64(env, argv[1], &dst)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_int(env, argv[2], &freesrc)) {
    return enif_make_badarg(env);
  }

  if (SDL_SaveBMP_RW(surface, dst, freesrc) < 0)
    return SDL_ERROR_TUPLE;

  return atom_ok;
}

static ERL_NIF_TERM sdl_save_bmp_nif(ErlNifEnv *env, int argc,
                                     const ERL_NIF_TERM argv[]) {
  SDL_Surface *surface;
  char file[256];

  if (!enif_get_uint64(env, argv[0], &surface)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_string(env, argv[0], file, 256, ERL_NIF_UTF8)) {
    return enif_make_badarg(env);
  }

  if (SDL_SaveBMP_RW(surface, SDL_RWFromFile(file, "wb"), 1) < 0)
    return SDL_ERROR_TUPLE;

  return atom_ok;
}

static ERL_NIF_TERM sdl_set_surface_rle_nif(ErlNifEnv *env, int argc,
                                            const ERL_NIF_TERM argv[]) {
  SDL_Surface *surface;
  int flag;

  if (!enif_get_uint64(env, argv[0], &surface)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_int(env, argv[1], &flag)) {
    return enif_make_badarg(env);
  }

  if (SDL_SetSurfaceRLE(surface, flag) < 0)
    return SDL_ERROR_TUPLE;

  return atom_ok;
}

static ERL_NIF_TERM sdl_has_surface_rle_nif(ErlNifEnv *env, int argc,
                                            const ERL_NIF_TERM argv[]) {
  SDL_Surface *surface;

  if (!enif_get_uint64(env, argv[0], &surface)) {
    return enif_make_badarg(env);
  }

  if (SDL_HasSurfaceRLE(surface) == SDL_TRUE) {
    return atom_true;
  }

  return atom_false;
}

static ERL_NIF_TERM sdl_set_color_key_nif(ErlNifEnv *env, int argc,
                                          const ERL_NIF_TERM argv[]) {
  SDL_Surface *surface;
  int flag;
  uint32_t key;

  if (!enif_get_uint64(env, argv[0], &surface)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_int(env, argv[1], &flag)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint(env, argv[2], &key)) {
    return enif_make_badarg(env);
  }

  if (SDL_SetColorKey(surface, flag, key) < 0)
    return SDL_ERROR_TUPLE;

  return atom_ok;
}

static ERL_NIF_TERM sdl_has_color_key_nif(ErlNifEnv *env, int argc,
                                          const ERL_NIF_TERM argv[]) {
  SDL_Surface *surface;

  if (!enif_get_uint64(env, argv[0], &surface)) {
    return enif_make_badarg(env);
  }

  if (SDL_HasColorKey(surface) == SDL_TRUE) {
    return atom_true;
  }

  return atom_false;
}

static ERL_NIF_TERM sdl_get_color_key_nif(ErlNifEnv *env, int argc,
                                          const ERL_NIF_TERM argv[]) {
  SDL_Surface *surface;
  uint32_t key;

  if (!enif_get_uint64(env, argv[0], &surface)) {
    return enif_make_badarg(env);
  }

  if (SDL_GetColorKey(surface, &key) < 0)
    return SDL_ERROR_TUPLE;

  return enif_make_tuple2(env, atom_ok, enif_make_uint(env, key));
}

// FIXME: segfaulting
static ERL_NIF_TERM sdl_set_surface_color_mod_nif(ErlNifEnv *env, int argc,
                                                  const ERL_NIF_TERM argv[]) {
  SDL_Surface *surface;
  uint8_t r, g, b;

  if (!enif_get_uint64(env, argv[0], &surface)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint(env, argv[1], &r)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint(env, argv[2], &g)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint(env, argv[3], &b)) {
    return enif_make_badarg(env);
  }

  if (SDL_SetSurfaceColorMod(surface, r, g, b) < 0)
    return SDL_ERROR_TUPLE;

  return atom_ok;
}

static ERL_NIF_TERM sdl_get_surface_color_mod_nif(ErlNifEnv *env, int argc,
                                                  const ERL_NIF_TERM argv[]) {
  SDL_Surface *surface;
  uint8_t r, g, b;

  if (!enif_get_uint64(env, argv[0], &surface)) {
    return enif_make_badarg(env);
  }

  if (SDL_GetSurfaceColorMod(surface, &r, &g, &b) < 0)
    return SDL_ERROR_TUPLE;

  ERL_NIF_TERM r_term = enif_make_uint(env, r);
  ERL_NIF_TERM g_term = enif_make_uint(env, g);
  ERL_NIF_TERM b_term = enif_make_uint(env, b);

  return enif_make_tuple2(env, atom_ok,
                          enif_make_tuple3(env, r_term, g_term, b_term));
}

static ERL_NIF_TERM sdl_set_surface_alpha_mod_nif(ErlNifEnv *env, int argc,
                                                  const ERL_NIF_TERM argv[]) {
  SDL_Surface *surface;
  uint8_t alpha;

  if (!enif_get_uint64(env, argv[0], &surface)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint(env, argv[1], &alpha)) {
    return enif_make_badarg(env);
  }

  if (SDL_SetSurfaceAlphaMod(surface, alpha) < 0)
    return SDL_ERROR_TUPLE;

  return atom_ok;
}

static ERL_NIF_TERM sdl_get_surface_alpha_mod_nif(ErlNifEnv *env, int argc,
                                                  const ERL_NIF_TERM argv[]) {
  SDL_Surface *surface;
  uint8_t alpha;

  if (!enif_get_uint64(env, argv[0], &surface)) {
    return enif_make_badarg(env);
  }

  if (SDL_GetSurfaceAlphaMod(surface, &alpha) < 0)
    return SDL_ERROR_TUPLE;

  ERL_NIF_TERM alpha_term = enif_make_uint(env, alpha);

  return enif_make_tuple2(env, atom_ok, alpha_term);
}

static ERL_NIF_TERM sdl_set_surface_blend_mode_nif(ErlNifEnv *env, int argc,
                                                   const ERL_NIF_TERM argv[]) {
  SDL_Surface *surface;
  SDL_BlendMode blend_mode;

  if (!enif_get_uint64(env, argv[0], &surface)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint64(env, argv[1], &blend_mode)) {
    return enif_make_badarg(env);
  }

  if (SDL_SetSurfaceBlendMode(surface, blend_mode) < 0)
    return SDL_ERROR_TUPLE;

  return atom_ok;
}

static ERL_NIF_TERM sdl_get_surface_blend_mode_nif(ErlNifEnv *env, int argc,
                                                   const ERL_NIF_TERM argv[]) {
  SDL_Surface *surface;
  SDL_BlendMode blend_mode;

  if (!enif_get_uint64(env, argv[0], &surface)) {
    return enif_make_badarg(env);
  }

  if (SDL_GetSurfaceAlphaMod(surface, &blend_mode) < 0)
    return SDL_ERROR_TUPLE;

  ERL_NIF_TERM blend_mode_term = enif_make_uint64(env, blend_mode);

  return enif_make_tuple2(env, atom_ok, blend_mode_term);
}

static ERL_NIF_TERM sdl_upper_blit_nif(ErlNifEnv *env, int argc,
                                       const ERL_NIF_TERM argv[]) {
  SDL_Surface *src, *dst;
  SDL_Rect *srcrect, *dstrect;

  if (!enif_get_uint64(env, argv[0], &src)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint64(env, argv[1], &srcrect)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint64(env, argv[2], &dst)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint64(env, argv[3], &dstrect)) {
    return enif_make_badarg(env);
  }

  if (SDL_UpperBlit(src, srcrect, dst, dstrect) != 0) {
    return SDL_ERROR_TUPLE;
  }

  return atom_ok;
}

static ERL_NIF_TERM sdl_get_video_driver_nif(ErlNifEnv *env, int argc,
                                             const ERL_NIF_TERM argv[]) {
  int index;

  if (!enif_get_int(env, argv[0], &index)) {
    return enif_make_badarg(env);
  }

  char *retval = SDL_GetVideoDriver(index);

  return enif_make_string(env, retval, ERL_NIF_UTF8);
}

static ERL_NIF_TERM sdl_video_init_nif(ErlNifEnv *env, int argc,
                                       const ERL_NIF_TERM argv[]) {
  char driver_name[256];

  if (!enif_get_string(env, argv[0], driver_name, 256, ERL_NIF_UTF8)) {
    return enif_make_badarg(env);
  }

  int retval = SDL_VideoInit(driver_name);

  if (retval != 0)
    return SDL_ERROR_TUPLE;

  return atom_ok;
}

static ERL_NIF_TERM sdl_create_window_nif(ErlNifEnv *env, int argc,
                                          const ERL_NIF_TERM argv[]) {
  char title[256];
  int x, y, w, h;
  uint32_t flags;

  if (!enif_get_string(env, argv[0], title, 256, ERL_NIF_UTF8)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_int(env, argv[1], &x)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_int(env, argv[2], &y)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_int(env, argv[3], &w)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_int(env, argv[4], &h)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint(env, argv[5], &flags)) {
    return enif_make_badarg(env);
  }

  SDL_Window *ref = SDL_CreateWindow(title, x, y, w, h, flags);

  if (ref == NULL)
    return SDL_ERROR_TUPLE;

  ERL_NIF_TERM keys[] = {atom_ref};
  ERL_NIF_TERM values[] = {enif_make_uint64(env, (uint64_t)ref)};
  ERL_NIF_TERM retval = enif_make_new_map(env);
  enif_make_map_from_arrays(env, keys, values, LEN(values), &retval);

  return enif_make_tuple2(env, atom_ok, retval);
}

static ERL_NIF_TERM sdl_get_window_surface_nif(ErlNifEnv *env, int argc,
                                               const ERL_NIF_TERM argv[]) {
  SDL_Window *window;

  if (!enif_get_uint64(env, argv[0], &window)) {
    return enif_make_badarg(env);
  }

  SDL_Surface *ref = SDL_GetWindowSurface(window);

  if (ref == NULL)
    return SDL_ERROR_TUPLE;

  return enif_make_tuple2(env, atom_ok, sdl_surface_map(env, ref));
}

static ERL_NIF_TERM sdl_create_renderer_nif(ErlNifEnv *env, int argc,
                                            const ERL_NIF_TERM argv[]) {
  SDL_Window *window;
  int index;
  uint32_t flags;

  if (!enif_get_uint64(env, argv[0], &window)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_int(env, argv[1], &index)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint(env, argv[2], &flags)) {
    return enif_make_badarg(env);
  }

  SDL_Renderer *ref = SDL_CreateRenderer(window, index, flags);

  if (ref == NULL)
    return SDL_ERROR_TUPLE;

  ERL_NIF_TERM keys[] = {atom_ref};
  ERL_NIF_TERM values[] = {enif_make_uint64(env, (uint64_t)ref)};
  ERL_NIF_TERM retval = enif_make_new_map(env);
  enif_make_map_from_arrays(env, keys, values, LEN(values), &retval);

  return enif_make_tuple2(env, atom_ok, retval);
}

static ERL_NIF_TERM
sdl_create_texture_from_surface_nif(ErlNifEnv *env, int argc,
                                    const ERL_NIF_TERM argv[]) {
  SDL_Renderer *renderer;
  SDL_Surface *surface;

  if (!enif_get_uint64(env, argv[0], &renderer)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint64(env, argv[1], &surface)) {
    return enif_make_badarg(env);
  }

  SDL_Texture *ref = SDL_CreateTextureFromSurface(renderer, surface);

  if (ref == NULL)
    return SDL_ERROR_TUPLE;

  ERL_NIF_TERM keys[] = {atom_ref};
  ERL_NIF_TERM values[] = {enif_make_uint64(env, (uint64_t)ref)};
  ERL_NIF_TERM retval = enif_make_new_map(env);
  enif_make_map_from_arrays(env, keys, values, LEN(values), &retval);

  return enif_make_tuple2(env, atom_ok, retval);
}

static ERL_NIF_TERM img_load_nif(ErlNifEnv *env, int argc,
                                 const ERL_NIF_TERM argv[]) {
  char file[256];

  if (!enif_get_string(env, argv[0], file, 256, ERL_NIF_UTF8)) {
    return enif_make_badarg(env);
  }

  SDL_Surface *ref = IMG_Load(file);

  if (ref == NULL)
    return SDL_ERROR_TUPLE;

  return enif_make_tuple2(env, atom_ok, sdl_surface_map(env, ref));
}

static ERL_NIF_TERM sdl_query_texture_nif(ErlNifEnv *env, int argc,
                                          const ERL_NIF_TERM argv[]) {
  SDL_Texture *texture;
  int w, h, access;
  uint32_t format;

  if (!enif_get_uint64(env, argv[0], &texture)) {
    return enif_make_badarg(env);
  }

  if (SDL_QueryTexture(texture, &format, &access, &w, &h) < 0)
    return SDL_ERROR_TUPLE;

  ERL_NIF_TERM format_term = enif_make_uint(env, format);
  ERL_NIF_TERM access_term = enif_make_int(env, access);
  ERL_NIF_TERM w_term = enif_make_int(env, w);
  ERL_NIF_TERM h_term = enif_make_int(env, h);

  return enif_make_tuple4(env, format_term, access_term, w_term, h_term);
}

static ERL_NIF_TERM sdl_render_clear_nif(ErlNifEnv *env, int argc,
                                         const ERL_NIF_TERM argv[]) {
  SDL_Renderer *renderer;

  if (!enif_get_uint64(env, argv[0], &renderer)) {
    return enif_make_badarg(env);
  }

  if (SDL_RenderClear(renderer) < 0)
    return SDL_ERROR_TUPLE;

  return atom_ok;
}

static ERL_NIF_TERM sdl_render_copy_nif(ErlNifEnv *env, int argc,
                                        const ERL_NIF_TERM argv[]) {
  SDL_Renderer *renderer;
  SDL_Texture *texture;
  SDL_Rect *srcrect;
  SDL_Rect *dstrect;

  if (!enif_get_uint64(env, argv[0], &renderer)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint64(env, argv[1], &texture)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint64(env, argv[2], &srcrect)) {
    return enif_make_badarg(env);
  }
  if (!enif_get_uint64(env, argv[3], &dstrect)) {
    return enif_make_badarg(env);
  }

  if (SDL_RenderCopy(renderer, texture, srcrect, dstrect) < 0)
    return SDL_ERROR_TUPLE;

  return atom_ok;
}

static ERL_NIF_TERM sdl_render_present_nif(ErlNifEnv *env, int argc,
                                           const ERL_NIF_TERM argv[]) {
  SDL_Renderer *renderer;

  if (!enif_get_uint64(env, argv[0], &renderer)) {
    return enif_make_badarg(env);
  }

  SDL_RenderPresent(renderer);

  return atom_ok;
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
    {"sdl_create_rgb_surface_from_nif", 9, sdl_create_rgb_surface_from_nif},
    {"sdl_create_rgb_surface_with_format_from_nif", 6,
     sdl_create_rgb_surface_with_format_from_nif},
    {"sdl_free_surface_nif", 1, sdl_free_surface_nif},
    {"sdl_set_surface_palette_nif", 2, sdl_set_surface_palette_nif},
    {"sdl_lock_surface_nif", 1, sdl_lock_surface_nif},
    {"sdl_unlock_surface_nif", 1, sdl_unlock_surface_nif},
    {"sdl_load_bmp_rw_nif", 2, sdl_load_bmp_rw_nif},
    {"sdl_load_bmp_nif", 1, sdl_load_bmp_nif},
    {"sdl_save_bmp_rw_nif", 3, sdl_save_bmp_rw_nif},
    {"sdl_save_bmp_nif", 2, sdl_save_bmp_nif},
    {"sdl_set_surface_rle_nif", 2, sdl_set_surface_rle_nif},
    {"sdl_has_surface_rle_nif", 1, sdl_has_surface_rle_nif},
    {"sdl_set_color_key_nif", 3, sdl_set_color_key_nif},
    {"sdl_has_color_key_nif", 1, sdl_has_color_key_nif},
    {"sdl_get_color_key_nif", 1,
     sdl_get_color_key_nif}, // takes 1 arg instead of 2
    {"sdl_set_surface_color_mod_nif", 4, sdl_set_surface_color_mod_nif},
    {"sdl_get_surface_color_mod_nif", 1,
     sdl_get_surface_color_mod_nif}, // takes 1 arg instead of 4
    {"sdl_set_surface_alpha_mod_nif", 2, sdl_set_surface_alpha_mod_nif},
    {"sdl_get_surface_alpha_mod_nif", 1,
     sdl_get_surface_alpha_mod_nif}, // takes 1 arg instead of 2
    {"sdl_set_surface_blend_mode_nif", 2, sdl_set_surface_blend_mode_nif},
    {"sdl_get_surface_blend_mode_nif", 1,
     sdl_get_surface_blend_mode_nif}, // takes 1 arg instead of 2
    /* {"sdl_set_clip_rect_nif", 2, sdl_set_clip_rect_nif}, */
    {"sdl_upper_blit_nif", 4, sdl_upper_blit_nif},
    // SDL_video.h section
    {"sdl_get_video_driver_nif", 1, sdl_get_video_driver_nif},
    {"sdl_video_init_nif", 1, sdl_video_init_nif},
    {"sdl_create_window_nif", 6, sdl_create_window_nif},
    {"sdl_get_window_surface_nif", 1, sdl_get_window_surface_nif},
    // SDL_render.h section
    {"sdl_create_renderer_nif", 3, sdl_create_renderer_nif},
    {"sdl_create_texture_from_surface_nif", 2,
     sdl_create_texture_from_surface_nif},
    // SDL_image.h section
    {"img_load_nif", 1, img_load_nif},
    // SDL_render.h section
    {"sdl_query_texture_nif", 1,
     sdl_query_texture_nif}, // use 1 arg instread of 5
    {"sdl_render_clear_nif", 1, sdl_render_clear_nif},
    {"sdl_render_copy_nif", 4, sdl_render_copy_nif},
    {"sdl_render_present_nif", 1, sdl_render_present_nif},
};

ERL_NIF_INIT(Elixir.Sdl, funcs, load, NULL, NULL, NULL)
