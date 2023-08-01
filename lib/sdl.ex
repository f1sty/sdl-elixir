defmodule Sdl do
  @moduledoc """
  Implements functions from `SDL.h`
  """
  @on_load :init_nifs
  def init_nifs do
    :erlang.load_nif(~c"c_src/sdl_nif", 0)
  end

  import Sdl.Helpers
  import Bitwise

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
  # @sdl_alpha_opaque 255
  # @sdl_alpha_transparent 0

  # @pixel_type_enum [
  #                    :sdl_pixeltype_unknown,
  #                    :sdl_pixeltype_index1,
  #                    :sdl_pixeltype_index4,
  #                    :sdl_pixeltype_index8,
  #                    :sdl_pixeltype_packed8,
  #                    :sdl_pixeltype_packed16,
  #                    :sdl_pixeltype_packed32,
  #                    :sdl_pixeltype_arrayu8,
  #                    :sdl_pixeltype_arrayu16,
  #                    :sdl_pixeltype_arrayu32,
  #                    :sdl_pixeltype_arrayf16,
  #                    :sdl_pixeltype_arrayf32
  #                  ]
  #                  |> Enum.with_index()
  #                  |> Map.new()

  # @bitmap_order_enum [:sdl_bitmaporder_none, :sdl_bitmaporder_4321, :sdl_bitmaporder_1234]
  #                    |> Enum.with_index()
  #                    |> Map.new()

  # @packed_order_enum [
  #                      :sdl_packedorder_none,
  #                      :sdl_packedorder_xrgb,
  #                      :sdl_packedorder_rgbx,
  #                      :sdl_packedorder_argb,
  #                      :sdl_packedorder_rgba,
  #                      :sdl_packedorder_xbgr,
  #                      :sdl_packedorder_bgrx,
  #                      :sdl_packedorder_abgr,
  #                      :sdl_packedorder_bgra
  #                    ]
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
  # @packed_layout_enum [
  #                       :sdl_packedlayout_none,
  #                       :sdl_packedlayout_332,
  #                       :sdl_packedlayout_4444,
  #                       :sdl_packedlayout_1555,
  #                       :sdl_packedlayout_5551,
  #                       :sdl_packedlayout_565,
  #                       :sdl_packedlayout_8888,
  #                       :sdl_packedlayout_2101010,
  #                       :sdl_packedlayout_1010102
  #                     ]
  #                     |> Enum.with_index()
  #                     |> Map.new()

  # this values are for little-endian, see `SDL2/SDL_pixels.h`
  @pixel_format_enum %{
    sdl_pixelformat_unknown: 0,
    sdl_pixelformat_index1lsb:
      sdl_define_pixelformat(:sdl_pixeltype_index1, :sdl_bitmaporder_4321, 0, 1, 0),
    sdl_pixelformat_index1msb:
      sdl_define_pixelformat(:sdl_pixeltype_index1, :sdl_bitmaporder_1234, 0, 1, 0),
    sdl_pixelformat_index4lsb:
      sdl_define_pixelformat(:sdl_pixeltype_index4, :sdl_bitmaporder_4321, 0, 4, 0),
    sdl_pixelformat_index4msb:
      sdl_define_pixelformat(:sdl_pixeltype_index4, :sdl_bitmaporder_1234, 0, 4, 0),
    sdl_pixelformat_index8: sdl_define_pixelformat(:sdl_pixeltype_index8, 0, 0, 8, 1),
    sdl_pixelformat_rgb332:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed8,
        :sdl_packedorder_xrgb,
        :sdl_packedlayout_332,
        8,
        1
      ),
    sdl_pixelformat_xrgb4444:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed16,
        :sdl_packedorder_xrgb,
        :sdl_packedlayout_4444,
        12,
        2
      ),
    sdl_pixelformat_rgb444:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed16,
        :sdl_packedorder_xrgb,
        :sdl_packedlayout_4444,
        12,
        2
      ),
    sdl_pixelformat_xbgr4444:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed16,
        :sdl_packedorder_xbgr,
        :sdl_packedlayout_4444,
        12,
        2
      ),
    sdl_pixelformat_bgr444:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed16,
        :sdl_packedorder_xbgr,
        :sdl_packedlayout_4444,
        12,
        2
      ),
    sdl_pixelformat_xrgb1555:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed16,
        :sdl_packedorder_xrgb,
        :sdl_packedlayout_1555,
        15,
        2
      ),
    sdl_pixelformat_rgb555:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed16,
        :sdl_packedorder_xrgb,
        :sdl_packedlayout_1555,
        15,
        2
      ),
    sdl_pixelformat_xbgr1555:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed16,
        :sdl_packedorder_xbgr,
        :sdl_packedlayout_1555,
        15,
        2
      ),
    sdl_pixelformat_bgr555:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed16,
        :sdl_packedorder_xbgr,
        :sdl_packedlayout_1555,
        15,
        2
      ),
    sdl_pixelformat_argb4444:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed16,
        :sdl_packedorder_argb,
        :sdl_packedlayout_4444,
        16,
        2
      ),
    sdl_pixelformat_rgba4444:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed16,
        :sdl_packedorder_rgba,
        :sdl_packedlayout_4444,
        16,
        2
      ),
    sdl_pixelformat_abgr4444:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed16,
        :sdl_packedorder_abgr,
        :sdl_packedlayout_4444,
        16,
        2
      ),
    sdl_pixelformat_bgra4444:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed16,
        :sdl_packedorder_bgra,
        :sdl_packedlayout_4444,
        16,
        2
      ),
    sdl_pixelformat_argb1555:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed16,
        :sdl_packedorder_argb,
        :sdl_packedlayout_1555,
        16,
        2
      ),
    sdl_pixelformat_rgba5551:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed16,
        :sdl_packedorder_rgba,
        :sdl_packedlayout_5551,
        16,
        2
      ),
    sdl_pixelformat_abgr1555:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed16,
        :sdl_packedorder_abgr,
        :sdl_packedlayout_1555,
        16,
        2
      ),
    sdl_pixelformat_bgra5551:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed16,
        :sdl_packedorder_bgra,
        :sdl_packedlayout_5551,
        16,
        2
      ),
    sdl_pixelformat_rgb565:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed16,
        :sdl_packedorder_xrgb,
        :sdl_packedlayout_565,
        16,
        2
      ),
    sdl_pixelformat_bgr565:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed16,
        :sdl_packedorder_xbgr,
        :sdl_packedlayout_565,
        16,
        2
      ),
    sdl_pixelformat_rgb24:
      sdl_define_pixelformat(:sdl_pixeltype_arrayu8, :sdl_arrayorder_rgb, 0, 24, 3),
    sdl_pixelformat_bgr24:
      sdl_define_pixelformat(:sdl_pixeltype_arrayu8, :sdl_arrayorder_bgr, 0, 24, 3),
    sdl_pixelformat_xrgb8888:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed32,
        :sdl_packedorder_xrgb,
        :sdl_packedlayout_8888,
        24,
        4
      ),
    sdl_pixelformat_rgb888:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed32,
        :sdl_packedorder_xrgb,
        :sdl_packedlayout_8888,
        24,
        4
      ),
    sdl_pixelformat_rgbx8888:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed32,
        :sdl_packedorder_rgbx,
        :sdl_packedlayout_8888,
        24,
        4
      ),
    sdl_pixelformat_xbgr8888:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed32,
        :sdl_packedorder_xbgr,
        :sdl_packedlayout_8888,
        24,
        4
      ),
    sdl_pixelformat_bgr888:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed32,
        :sdl_packedorder_xbgr,
        :sdl_packedlayout_8888,
        24,
        4
      ),
    sdl_pixelformat_bgrx8888:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed32,
        :sdl_packedorder_bgrx,
        :sdl_packedlayout_8888,
        24,
        4
      ),
    sdl_pixelformat_argb8888:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed32,
        :sdl_packedorder_argb,
        :sdl_packedlayout_8888,
        32,
        4
      ),
    sdl_pixelformat_rgba8888:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed32,
        :sdl_packedorder_rgba,
        :sdl_packedlayout_8888,
        32,
        4
      ),
    sdl_pixelformat_abgr8888:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed32,
        :sdl_packedorder_abgr,
        :sdl_packedlayout_8888,
        32,
        4
      ),
    sdl_pixelformat_bgra8888:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed32,
        :sdl_packedorder_bgra,
        :sdl_packedlayout_8888,
        32,
        4
      ),
    sdl_pixelformat_argb2101010:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed32,
        :sdl_packedorder_argb,
        :sdl_packedlayout_2101010,
        32,
        4
      ),
    sdl_pixelformat_rgba32:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed32,
        :sdl_packedorder_abgr,
        :sdl_packedlayout_8888,
        32,
        4
      ),
    sdl_pixelformat_argb32:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed32,
        :sdl_packedorder_bgra,
        :sdl_packedlayout_8888,
        32,
        4
      ),
    sdl_pixelformat_bgra32:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed32,
        :sdl_packedorder_argb,
        :sdl_packedlayout_8888,
        32,
        4
      ),
    sdl_pixelformat_abgr32:
      sdl_define_pixelformat(
        :sdl_pixeltype_packed32,
        :sdl_packedorder_rgba,
        :sdl_packedlayout_8888,
        32,
        4
      ),
    sdl_pixelformat_yv12: sdl_define_pixelfourcc(?y, ?v, ?1, ?2),
    sdl_pixelformat_iyuv: sdl_define_pixelfourcc(?i, ?y, ?u, ?v),
    sdl_pixelformat_yuy2: sdl_define_pixelfourcc(?y, ?u, ?y, ?2),
    sdl_pixelformat_uyvy: sdl_define_pixelfourcc(?u, ?y, ?v, ?y),
    sdl_pixelformat_yvyu: sdl_define_pixelfourcc(?y, ?v, ?y, ?u),
    sdl_pixelformat_nv12: sdl_define_pixelfourcc(?n, ?v, ?1, ?2),
    sdl_pixelformat_nv21: sdl_define_pixelfourcc(?n, ?v, ?2, ?1),
    sdl_pixelformat_external_oes: sdl_define_pixelfourcc(?o, ?e, ?s, ?\s)
  }

  # @sdl_yuv_conversion_mode_enum [
  #                                 :sdl_yuv_conversion_jpeg,
  #                                 :sdl_yuv_conversion_bt601,
  #                                 :sdl_yuv_conversion_bt709,
  #                                 :sdl_yuv_conversion_automatic
  #                               ]
  #                               |> Enum.with_index()
  #                               |> Map.new()

  defmodule Colour do
    defstruct r: 0, g: 0, b: 0, a: 0, ref: nil

    def new(nil), do: nil

    def new(config) do
      Map.merge(%__MODULE__{}, config)
    end
  end

  defmodule Color do
    defstruct r: 0, g: 0, b: 0, a: 0, ref: nil

    def new(nil), do: nil

    def new(config) do
      Map.merge(%__MODULE__{}, config)
    end
  end

  defmodule Palette do
    defstruct ncolors: 0,
              colors: nil,
              version: 0,
              refcount: 0,
              ref: nil

    def new(nil), do: nil

    def new(%{colors: colors_config} = config) do
      config = %{config | colors: Color.new(colors_config)}
      Map.merge(%__MODULE__{}, config)
    end
  end

  defmodule PixelFormat do
    defstruct format: 0,
              palette: nil,
              bits_per_pixel: 0,
              bytes_per_pixel: 0,
              padding: [],
              r_mask: 0,
              g_mask: 0,
              b_mask: 0,
              a_mask: 0,
              r_loss: 0,
              g_loss: 0,
              b_loss: 0,
              a_loss: 0,
              r_shift: 0,
              g_shift: 0,
              b_shift: 0,
              a_shift: 0,
              refcount: 0,
              next: nil,
              ref: nil

    def new(nil), do: nil

    def new(%{palette: palette_config} = config) do
      config = %{config | palette: Palette.new(palette_config)}
      Map.merge(%__MODULE__{}, config)
    end
  end

  defmodule Rect do
    defstruct x: 0, y: 0, w: 0, h: 0, ref: nil

    def new(nil), do: nil

    def new(config) do
      Map.merge(%__MODULE__{}, config)
    end
  end

  defmodule FRect do
    defstruct x: 0.0, y: 0.0, w: 0.0, h: 0.0, ref: nil

    def new(nil), do: nil

    def new(config) do
      Map.merge(%__MODULE__{}, config)
    end
  end

  defmodule Point do
    defstruct x: 0, y: 0, ref: nil

    def new(nil), do: nil

    def new(config) do
      Map.merge(%__MODULE__{}, config)
    end
  end

  defmodule FPoint do
    defstruct x: 0.0, y: 0.0, ref: nil

    def new(nil), do: nil

    def new(config) do
      Map.merge(%__MODULE__{}, config)
    end
  end

  defmodule Surface do
    @moduledoc """
    Implements `SDL2/SDL_surface.h` functions
    """

    # @surface_flags_mappings %{
    #   sdl_swsurface: 0,
    #   sdl_prealloc: 0x00000001,
    #   sdl_rleaccel: 0x00000002,
    #   sdl_dontfree: 0x00000004,
    #   sdl_simd_aligned: 0x00000008
    # }

    defstruct flags: 0,
              format: nil,
              w: 0,
              h: 0,
              pitch: 0,
              pixels: nil,
              userdata: nil,
              locked: false,
              list_blitmap: nil,
              clip_rect: nil,
              map: nil,
              refcount: 0,
              ref: nil

    def new(nil), do: nil

    def new(%{clip_rect: clip_rect_config, format: pixel_format_config} = config) do
      config = %{
        config
        | clip_rect: Rect.new(clip_rect_config),
          format: PixelFormat.new(pixel_format_config)
      }

      Map.merge(%__MODULE__{}, config)
    end
  end

  defmodule RWops do
    defstruct [:type, :hidden, :ref]

    def new(nil), do: nil

    def new(config) do
      Map.merge(%__MODULE__{}, config)
    end

    def size(_rw_ops), do: 0
    def seek(_rw_ops, _offset, _whence), do: 0
    def read(_rw_ops, _ptr, _size, _maxnum), do: 0
    def write(_rw_ops, _ptr, _size, _num), do: 0
    def close(_rw_ops), do: 0
  end

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
    with format = Map.get(@pixel_format_enum, format, 0),
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
    with format = Map.get(@pixel_format_enum, format, 0),
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

  def int_to_enum_values(blend_mode, enum) do
    Enum.reject(enum, fn {_k, v} -> (v &&& blend_mode) == 0 end) |> Keyword.keys()
  end

  # `SDL2/SDL_video.h` section

  defmodule Window do
    defstruct [:ref]

    def new(config) do
      Map.merge(%__MODULE__{}, config)
    end
  end

  def sdl_get_video_driver_nif(_index), do: nif_not_loaded!()
  def sdl_video_init_nif(_driver_name), do: nif_not_loaded!()
  def sdl_create_window_nif(_title, _x, _y, _w, _h, _flags), do: nif_not_loaded!()

  def sdl_get_video_driver(index), do: sdl_get_video_driver_nif(index) |> to_string()
  def sdl_video_init(driver_name), do: driver_name |> to_charlist() |> sdl_video_init_nif()

  def sdl_create_window(title, x, y, w, h, flags) do
    with flags = from_list(flags, @window_flags_enum),
         title = to_charlist(title),
         {:ok, window} <- sdl_create_window_nif(title, x, y, w, h, flags) do
      Window.new(window)
    end
  end
end
