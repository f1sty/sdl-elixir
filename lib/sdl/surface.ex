defmodule Sdl.Surface do
  alias Sdl.{PixelFormat, Rect}

  import Sdl.Helpers

  @surface_flags %{
    sdl_swsurface: 0,
    sdl_prealloc: 0x00000001,
    sdl_rleaccel: 0x00000002,
    sdl_dontfree: 0x00000004,
    sdl_simd_aligned: 0x00000008
  }

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

  def new(%{flags: flags, clip_rect: clip_rect_config, format: pixel_format_config} = config) do
    flags = int_to_enum_values(flags, @surface_flags)

    config = %{
      config
      | clip_rect: Rect.new(clip_rect_config),
        format: PixelFormat.new(pixel_format_config),
        flags: flags
    }

    Map.merge(%__MODULE__{}, config)
  end
end
