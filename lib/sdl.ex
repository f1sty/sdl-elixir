defmodule Sdl do
  @moduledoc """
  Wraps NIFs
  """
  @on_load :init_nifs
  def init_nifs do
    :erlang.load_nif(~c"c_src/sdl_nif", 0)
  end

  import Bitwise
  import Sdl.Helpers

  alias Sdl.{Surface, Palette, RWops, Renderer, Texture, Window, Event}

  @sdl_windowpos_undefined 0x1FFF0000
  @sdl_windowpos_centered 0x2FFF0000

  @sdl_windowpos_enum %{
    sdl_windowpos_centered: @sdl_windowpos_centered,
    sdl_windowpos_undefined: @sdl_windowpos_undefined
  }

  @flags_mappings %{
    sdl_init_timer: 0x00000001,
    sdl_init_audio: 0x00000010,
    sdl_init_video: 0x00000020,
    sdl_init_joystick: 0x00000200,
    sdl_init_haptic: 0x00001000,
    sdl_init_gamecontroller: 0x00002000,
    sdl_init_events: 0x00004000,
    sdl_init_sensor: 0x00008000,
    sdl_init_noparachute: 0x00100000,
    sdl_init_everything:
      0x00000001 |||
        0x00000010 |||
        0x00000020 |||
        0x00004000 |||
        0x00000200 |||
        0x00001000 |||
        0x00002000 |||
        0x00008000
  }

  @blend_mode_enum %{
    sdl_blendmode_none: 0x00000000,
    sdl_blendmode_blend: 0x00000001,
    sdl_blendmode_add: 0x00000002,
    sdl_blendmode_mod: 0x00000004,
    sdl_blendmode_mul: 0x00000008,
    sdl_blendmode_invalid: 0x7FFFFFFF
  }

  @window_flags_enum %{
    sdl_window_fullscreen: 0x00000001,
    sdl_window_opengl: 0x00000002,
    sdl_window_shown: 0x00000004,
    sdl_window_hidden: 0x00000008,
    sdl_window_borderless: 0x00000010,
    sdl_window_resizable: 0x00000020,
    sdl_window_minimized: 0x00000040,
    sdl_window_maximized: 0x00000080,
    sdl_window_mouse_grabbed: 0x00000100,
    sdl_window_input_focus: 0x00000200,
    sdl_window_mouse_focus: 0x00000400,
    sdl_window_fullscreen_desktop: 0x00001001,
    sdl_window_foreign: 0x00000800,
    sdl_window_allow_highdpi: 0x00002000,
    sdl_window_mouse_capture: 0x00004000,
    sdl_window_always_on_top: 0x00008000,
    sdl_window_skip_taskbar: 0x00010000,
    sdl_window_utility: 0x00020000,
    sdl_window_tooltip: 0x00040000,
    sdl_window_popup_menu: 0x00080000,
    sdl_window_keyboard_grabbed: 0x00100000,
    sdl_window_vulkan: 0x10000000,
    sdl_window_metal: 0x20000000,
    sdl_window_input_grabbed: 0x00000100
  }

  @sdl_renderer_flags %{
    sdl_renderer_software: 0x00000001,
    sdl_renderer_accelerated: 0x00000002,
    sdl_renderer_presentvsync: 0x00000004,
    sdl_renderer_targettexture: 0x00000008
  }
  # @sdl_alpha_opaque 255
  # @sdl_alpha_transparent 0

  # @bitmap_order_enum [:sdl_bitmaporder_none, :sdl_bitmaporder_4321, :sdl_bitmaporder_1234]
  #                    |> Enum.with_index()
  #                    |> Map.new()

  # @array_order_enum [
  #                     :sdl_arrayorder_none,
  #                     :sdl_arrayorder_rgb,
  #                     :sdl_arrayorder_rgba,
  #                     :sdl_arrayorder_argb,
  #                     :sdl_arrayorder_bgr,
  #                     :sdl_arrayorder_bgra,
  #                     :sdl_arrayorder_abgr
  #                   ]
  #                   |> Enum.with_index()
  #                   |> Map.new()

  # @sdl_yuv_conversion_mode_enum [
  #                                 :sdl_yuv_conversion_jpeg,
  #                                 :sdl_yuv_conversion_bt601,
  #                                 :sdl_yuv_conversion_bt709,
  #                                 :sdl_yuv_conversion_automatic
  #                               ]
  #                               |> Enum.with_index()
  #                               |> Map.new()

  # `SDL2/SDL.h` functions
  def sdl_init_nif(_flags), do: nif_not_loaded!()
  def sdl_init_sub_system_nif(_flags), do: nif_not_loaded!()
  def sdl_quit_sub_system_nif(_flags), do: nif_not_loaded!()
  def sdl_was_init_nif(_flags), do: nif_not_loaded!()
  def sdl_quit_nif(), do: nif_not_loaded!()

  def sdl_init(flags), do: flags |> from_list(@flags_mappings) |> sdl_init_nif()

  def sdl_init_sub_system(flags),
    do: flags |> from_list(@flags_mappings) |> sdl_init_sub_system_nif()

  def sdl_quit_sub_system(flags),
    do: flags |> from_list(@flags_mappings) |> sdl_quit_sub_system_nif()

  def sdl_was_init(flags), do: flags |> from_list(@flags_mappings) |> sdl_was_init_nif()
  def sdl_quit, do: sdl_quit_nif()

  # `SDL2/SDL_surface.h` functions
  def sdl_create_rgb_surface_nif(
        _flags,
        _width,
        _height,
        _depth,
        _r_mask,
        _g_mask,
        _b_mask,
        _a_mask
      ) do
    nif_not_loaded!()
  end

  def sdl_create_rgb_surface_with_format_nif(_flags, _width, _height, _depth, _format) do
    nif_not_loaded!()
  end

  def sdl_create_rgb_surface_from_nif(
        _pixels,
        _width,
        _height,
        _depth,
        _pitch,
        _r_mask,
        _g_mask,
        _b_mask,
        _a_mask
      ) do
    nif_not_loaded!()
  end

  def sdl_create_rgb_surface_with_format_from_nif(
        _pixels,
        _width,
        _height,
        _depth,
        _pitch,
        _format
      ) do
    nif_not_loaded!()
  end

  def sdl_free_surface_nif(_surface), do: nif_not_loaded!()
  def sdl_set_surface_palette_nif(_surface, _palette), do: nif_not_loaded!()
  def sdl_lock_surface_nif(_surface), do: nif_not_loaded!()
  def sdl_unlock_surface_nif(_surface), do: nif_not_loaded!()
  def sdl_load_bmp_rw_nif(_rw_ops, _freesrc), do: nif_not_loaded!()
  def sdl_load_bmp_nif(_file), do: nif_not_loaded!()
  def sdl_save_bmp_rw_nif(_surface, _dst, _freesrc), do: nif_not_loaded!()
  def sdl_save_bmp_nif(_surface, _file), do: nif_not_loaded!()
  def sdl_set_surface_rle_nif(_surface, _flag), do: nif_not_loaded!()
  def sdl_has_surface_rle_nif(_surface), do: nif_not_loaded!()
  def sdl_set_color_key_nif(_surface, _flag, _key), do: nif_not_loaded!()
  def sdl_has_color_key_nif(_surface), do: nif_not_loaded!()
  def sdl_get_color_key_nif(_surface), do: nif_not_loaded!()
  def sdl_set_surface_color_mod_nif(_surface, _r, _g, _b), do: nif_not_loaded!()
  def sdl_get_surface_color_mod_nif(_surface), do: nif_not_loaded!()
  def sdl_set_surface_alpha_mod_nif(_surface, _alpha), do: nif_not_loaded!()
  def sdl_get_surface_alpha_mod_nif(_surface), do: nif_not_loaded!()
  def sdl_set_surface_blend_mode_nif(_surface, _blend_mode), do: nif_not_loaded!()
  def sdl_get_surface_blend_mode_nif(_surface), do: nif_not_loaded!()
  # def sdl_set_clip_rect_nif(_surface, _rect), do: nif_not_loaded!()
  def sdl_upper_blit_nif(_src, _srcrect, _dst, _dst_rect), do: nif_not_loaded!()

  def sdl_create_rgb_surface(flags, width, height, depth, r_mask, g_mask, b_mask, a_mask) do
    with {:ok, surface} <-
           sdl_create_rgb_surface_nif(flags, width, height, depth, r_mask, g_mask, b_mask, a_mask) do
      Surface.new(surface)
    end
  end

  def sdl_create_rgb_surface_with_format(flags, width, height, depth, format) do
    with format = Map.get(pixel_format_enum(), format, 0),
         {:ok, surface} <-
           sdl_create_rgb_surface_with_format_nif(flags, width, height, depth, format) do
      Surface.new(surface)
    end
  end

  def sdl_create_rgb_surface_from(
        pixels,
        width,
        height,
        depth,
        pitch,
        r_mask,
        g_mask,
        b_mask,
        a_mask
      ) do
    with {:ok, surface} <-
           sdl_create_rgb_surface_from_nif(
             pixels,
             width,
             height,
             depth,
             pitch,
             r_mask,
             g_mask,
             b_mask,
             a_mask
           ) do
      Surface.new(surface)
    end
  end

  def sdl_create_rgb_surface_with_format_from(pixels, width, height, depth, pitch, format) do
    with format = Map.get(pixel_format_enum(), format, 0),
         {:ok, surface} <-
           sdl_create_rgb_surface_with_format_from_nif(
             pixels,
             width,
             height,
             depth,
             pitch,
             format
           ) do
      Surface.new(surface)
    end
  end

  def sdl_free_surface(%Surface{ref: ref}), do: sdl_free_surface_nif(ref)

  def sdl_set_surface_palette(%Surface{ref: surface_ref}, %Palette{ref: palette_ref}) do
    with {:ok, surface} <- sdl_set_surface_palette_nif(surface_ref, palette_ref) do
      Surface.new(surface)
    end
  end

  def sdl_lock_surface(%Surface{ref: ref}) do
    with {:ok, surface} <- sdl_lock_surface_nif(ref) do
      Surface.new(surface)
    end
  end

  def sdl_unlock_surface(%Surface{ref: ref}), do: sdl_unlock_surface_nif(ref)

  def sdl_load_bmp_rw(%RWops{ref: src}, freesrc) do
    with {:ok, surface} <- sdl_load_bmp_rw_nif(src, freesrc) do
      Surface.new(surface)
    end
  end

  def sdl_load_bmp(file) do
    with file = to_charlist(file),
         {:ok, surface} <- sdl_load_bmp_nif(file) do
      Surface.new(surface)
    end
  end

  def sdl_save_bmp_rw(%Surface{ref: surface_ref}, %RWops{ref: rw_ops_ref}, freesrc) do
    sdl_save_bmp_rw_nif(surface_ref, rw_ops_ref, freesrc)
  end

  def sdl_save_bmp(%Surface{ref: ref}, file) do
    file = to_charlist(file)
    sdl_save_bmp_nif(ref, file)
  end

  def sdl_set_surface_rle(%Surface{ref: ref}, flag) do
    flag = (flag && 1) || 0
    sdl_set_surface_rle_nif(ref, flag)
  end

  def sdl_has_surface_rle(%Surface{ref: ref}) do
    sdl_has_surface_rle_nif(ref)
  end

  def sdl_set_color_key(%Surface{ref: ref}, flag, key) do
    flag = (flag && 1) || 0
    sdl_set_color_key_nif(ref, flag, key)
  end

  def sdl_has_color_key(%Surface{ref: ref}) do
    sdl_has_color_key_nif(ref)
  end

  def sdl_get_color_key(%Surface{ref: ref}) do
    sdl_get_color_key_nif(ref)
  end

  def sdl_set_surface_color_mod(%Surface{ref: ref}, r, g, b) do
    sdl_set_surface_color_mod_nif(ref, r, g, b)
  end

  def sdl_get_surface_color_mod(%Surface{ref: ref}) do
    with {:ok, color_mode} <- sdl_get_surface_color_mod_nif(ref) do
      color_mode
    end
  end

  def sdl_set_surface_alpha_mod(%Surface{ref: ref}, alpha) do
    sdl_set_surface_alpha_mod_nif(ref, alpha)
  end

  def sdl_get_surface_alpha_mod(%Surface{ref: ref}) do
    with {:ok, alpha} <- sdl_get_surface_alpha_mod_nif(ref) do
      alpha
    end
  end

  def sdl_set_surface_blend_mode(%Surface{ref: ref}, blend_mode) do
    blend_mode = Map.get(@blend_mode_enum, blend_mode, 0)
    sdl_set_surface_blend_mode_nif(ref, blend_mode)
  end

  def sdl_get_surface_blend_mode(%Surface{ref: ref}) do
    with {:ok, blend_mode} <- sdl_get_surface_blend_mode_nif(ref) do
      int_to_enum_values(blend_mode, @blend_mode_enum)
    end
  end

  # def sdl_set_clip_rect(%Surface{ref: surface_ref}, %Rect{ref: rect_ref}) do
  #   sdl_set_clip_rect_nif(surface_ref, rect_ref)
  # end

  def sdl_upper_blit(%Surface{ref: src}, srcrect, %Surface{ref: dst}, dstrect) do
    srcrect =
      case is_map(srcrect) do
        true -> Map.get(srcrect, :ref)
        false -> 0
      end

    dstrect =
      case is_map(dstrect) do
        true -> Map.get(dstrect, :ref)
        false -> 0
      end

    sdl_upper_blit_nif(src, srcrect, dst, dstrect)
  end

  def sdl_blit_surface(%Surface{ref: src}, srcrect, %Surface{ref: dst}, dstrect) do
    srcrect =
      case is_map(srcrect) do
        true -> Map.get(srcrect, :ref)
        false -> 0
      end

    dstrect =
      case is_map(dstrect) do
        true -> Map.get(dstrect, :ref)
        false -> 0
      end

    sdl_upper_blit_nif(src, srcrect, dst, dstrect)
  end

  # `SDL2/SDL_video.h` section
  def sdl_get_video_driver_nif(_index), do: nif_not_loaded!()
  def sdl_video_init_nif(_driver_name), do: nif_not_loaded!()
  def sdl_create_window_nif(_title, _x, _y, _w, _h, _flags), do: nif_not_loaded!()
  def sdl_get_window_surface_nif(_window), do: nif_not_loaded!()
  def sdl_destroy_window_nif(_window), do: nif_not_loaded!()

  def sdl_get_video_driver(index), do: sdl_get_video_driver_nif(index) |> to_string()
  def sdl_video_init(driver_name), do: driver_name |> to_charlist() |> sdl_video_init_nif()

  def sdl_create_window(title, x, y, w, h, flags) do
    x = (is_atom(x) && Map.get(@sdl_windowpos_enum, x, 0)) || x
    y = (is_atom(y) && Map.get(@sdl_windowpos_enum, y, 0)) || y

    with flags = from_list(flags, @window_flags_enum),
         title = to_charlist(title),
         {:ok, window} <- sdl_create_window_nif(title, x, y, w, h, flags) do
      Window.new(window)
    end
  end

  def sdl_get_window_surface(%Window{ref: ref}) do
    with {:ok, surface} <- sdl_get_window_surface_nif(ref) do
      Surface.new(surface)
    end
  end

  def sdl_destroy_window(%Window{ref: ref}) do
    sdl_destroy_window_nif(ref)
  end

  # `SDL2/SDL_render.h` section
  def sdl_create_renderer_nif(_window, _index, _flags), do: nif_not_loaded!()
  def sdl_create_texture_from_surface_nif(_renderer, _surface), do: nif_not_loaded!()

  def sdl_create_renderer(%Window{ref: ref}, index, flags) do
    with flags = from_list(flags, @sdl_renderer_flags),
         {:ok, renderer} <- sdl_create_renderer_nif(ref, index, flags) do
      Renderer.new(renderer)
    end
  end

  def sdl_create_texture_from_surface(%Renderer{ref: renderer_ref}, %Surface{ref: surface_ref}) do
    with {:ok, texture} <- sdl_create_texture_from_surface_nif(renderer_ref, surface_ref) do
      Texture.new(texture)
    end
  end

  # `SDL2/SDL_image.h` secction
  def img_load_nif(_file), do: nif_not_loaded!()

  def img_load(file) do
    with file = to_charlist(file),
         {:ok, surface} <- img_load_nif(file) do
      Surface.new(surface)
    end
  end

  # `SDL2/SDL_render.h` section
  def sdl_query_texture_nif(_texture), do: nif_not_loaded!()
  def sdl_render_clear_nif(_renderer), do: nif_not_loaded!()
  def sdl_render_copy_nif(_renderer, _texture, _srcrect, _dstrect), do: nif_not_loaded!()
  def sdl_render_present_nif(_renderer), do: nif_not_loaded!()
  def sdl_destroy_texture_nif(_texture), do: nif_not_loaded!()
  def sdl_destroy_renderer_nif(_renderer), do: nif_not_loaded!()

  def sdl_query_texture(%Texture{ref: ref}) do
    sdl_query_texture_nif(ref)
  end

  def sdl_render_clear(%Renderer{ref: ref}) do
    sdl_render_clear_nif(ref)
  end

  def sdl_render_copy(
        %Renderer{ref: renderer_ref},
        %Texture{ref: texture_ref},
        srcrect,
        dstrect
      ) do
    srcrect = (is_nil(srcrect) && 0) || Map.get(srcrect, :ref, 0)
    dstrect = (is_nil(dstrect) && 0) || Map.get(dstrect, :ref, 0)
    sdl_render_copy_nif(renderer_ref, texture_ref, srcrect, dstrect)
  end

  def sdl_render_present(%Renderer{ref: ref}) do
    sdl_render_present_nif(ref)
  end

  def sdl_destroy_texture(%Texture{ref: ref}) do
    sdl_destroy_texture_nif(ref)
  end

  def sdl_destroy_renderer(%Renderer{ref: ref}) do
    sdl_destroy_renderer_nif(ref)
  end

  # `SDL2/SDL_events.h` section
  def sdl_poll_event_nif(), do: nif_not_loaded!()

  def sdl_poll_event() do
    sdl_poll_event_nif() |> Event.new()
  end
end
