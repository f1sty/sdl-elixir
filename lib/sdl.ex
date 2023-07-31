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

  @sdl_alpha_opaque 255
  @sdl_alpha_transparent 0

  @pixel_type_enum [
                     :sdl_pixeltype_unknown,
                     :sdl_pixeltype_index1,
                     :sdl_pixeltype_index4,
                     :sdl_pixeltype_index8,
                     :sdl_pixeltype_packed8,
                     :sdl_pixeltype_packed16,
                     :sdl_pixeltype_packed32,
                     :sdl_pixeltype_arrayu8,
                     :sdl_pixeltype_arrayu16,
                     :sdl_pixeltype_arrayu32,
                     :sdl_pixeltype_arrayf16,
                     :sdl_pixeltype_arrayf32
                   ]
                   |> Enum.with_index()
                   |> Map.new()

  @bitmap_order_enum [:sdl_bitmaporder_none, :sdl_bitmaporder_4321, :sdl_bitmaporder_1234]
                     |> Enum.with_index()
                     |> Map.new()

  @packed_order_enum [
                       :sdl_packedorder_none,
                       :sdl_packedorder_xrgb,
                       :sdl_packedorder_rgbx,
                       :sdl_packedorder_argb,
                       :sdl_packedorder_rgba,
                       :sdl_packedorder_xbgr,
                       :sdl_packedorder_bgrx,
                       :sdl_packedorder_abgr,
                       :sdl_packedorder_bgra
                     ]
                     |> Enum.with_index()
                     |> Map.new()

  @array_order_enum [
                      :sdl_arrayorder_none,
                      :sdl_arrayorder_rgb,
                      :sdl_arrayorder_rgba,
                      :sdl_arrayorder_argb,
                      :sdl_arrayorder_bgr,
                      :sdl_arrayorder_bgra,
                      :sdl_arrayorder_abgr
                    ]
                    |> Enum.with_index()
                    |> Map.new()
  @packed_layout_enum [
                        :sdl_packedlayout_none,
                        :sdl_packedlayout_332,
                        :sdl_packedlayout_4444,
                        :sdl_packedlayout_1555,
                        :sdl_packedlayout_5551,
                        :sdl_packedlayout_565,
                        :sdl_packedlayout_8888,
                        :sdl_packedlayout_2101010,
                        :sdl_packedlayout_1010102
                      ]
                      |> Enum.with_index()
                      |> Map.new()

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

  @sdl_yuv_conversion_mode_enum [
                                  :sdl_yuv_conversion_jpeg,
                                  :sdl_yuv_conversion_bt601,
                                  :sdl_yuv_conversion_bt709,
                                  :sdl_yuv_conversion_automatic
                                ]
                                |> Enum.with_index()
                                |> Map.new()

  defmodule Colour do
    defstruct r: 0, g: 0, b: 0, a: 0, ref: nil

    def new(config \\ %{}) do
      Map.merge(%__MODULE__{}, config)
    end
  end

  defmodule Color do
    defstruct r: 0, g: 0, b: 0, a: 0, ref: nil

    def new(config \\ %{}) do
      Map.merge(%__MODULE__{}, config)
    end
  end

  defmodule Palette do
    defstruct ncolors: 0,
              colors: [Color.new()],
              version: 0,
              refcount: 0,
              ref: nil

    def new(config \\ %{}) do
      Map.merge(%__MODULE__{}, config)
    end
  end

  defmodule PixelFormat do
    defstruct format: @pixel_format_enum[:sdl_pixelformat_unknown],
              palette: Palette.new(),
              bits_per_pixel: 0,
              bytes_per_pixel: 0,
              padding: [0, 0],
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

    def new(config \\ %{}) do
      Map.merge(%__MODULE__{}, config)
    end
  end

  defmodule Rect do
    defstruct x: 0, y: 0, w: 0, h: 0, ref: nil

    def new(config \\ %{}) do
      Map.merge(%__MODULE__{}, config)
    end
  end

  defmodule FRect do
    defstruct x: 0.0, y: 0.0, w: 0.0, h: 0.0, ref: nil

    def new(config \\ %{}) do
      Map.merge(%__MODULE__{}, config)
    end
  end

  defmodule Point do
    defstruct x: 0, y: 0, ref: nil

    def new(config \\ %{}) do
      Map.merge(%__MODULE__{}, config)
    end
  end

  defmodule FPoint do
    defstruct x: 0.0, y: 0.0, ref: nil

    def new(config \\ %{}) do
      Map.merge(%__MODULE__{}, config)
    end
  end

  defmodule Surface do
    @moduledoc """
    Implements `SDL2/SDL_surface.h` functions
    """

    @surface_flags_mappings %{
      sdl_swsurface: 0,
      sdl_prealloc: 0x00000001,
      sdl_rleaccel: 0x00000002,
      sdl_dontfree: 0x00000004,
      sdl_simd_aligned: 0x00000008
    }

    defstruct flags: 0,
              format: PixelFormat.new(),
              w: 0,
              h: 0,
              pitch: 0,
              pixels: nil,
              userdata: nil,
              locked: false,
              list_blitmap: nil,
              clip_rect: Rect.new(),
              map: nil,
              refcount: 0,
              ref: nil

    def new(config \\ %{}) do
      Map.merge(%__MODULE__{}, config)
    end
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
  def sdl_create_rgb_surface_nif(_flags, _width, _height, _depth, _r_mask, _g_mask, _b_mask, _a_mask) do
    nif_not_loaded!()
  end

  def sdl_create_rgb_surface_with_format_nif(_flags, _width, _height, _depth, _format) do
    nif_not_loaded!()
  end

  def sdl_create_rgb_surface(flags, width, height, depth, r_mask, g_mask, b_mask, a_mask) do
    sdl_create_rgb_surface_nif(flags, width, height, depth, r_mask, g_mask, b_mask, a_mask)
  end

  def sdl_create_rgb_surface_with_format(flags, width, height, depth, format) do
    format = Map.get(@pixel_format_enum, format, 0)
    sdl_create_rgb_surface_with_format_nif(flags, width, height, depth, format)
  end
end
