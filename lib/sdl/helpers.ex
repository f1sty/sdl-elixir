defmodule Sdl.Helpers do
  @moduledoc """
  Helper functions for other modules.
  """

  import Bitwise

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
  defmodule NifNotLoaded do
    defexception [:message]
  end

  def nif_not_loaded! do
    raise NifNotLoaded, message: "could not load c_src/sdl_nif.so"
  end

  def from_list(flags, mappings) do
    Enum.reduce(flags, 0, fn flag, acc -> bor(acc, mappings[flag]) end)
  end

  def sdl_define_pixelformat(type, order, layout, bits, bytes) do
    type = Map.get(@pixel_type_enum, type, 0)
    order = Map.get(@packed_order_enum, order, 0)
    layout = Map.get(@packed_layout_enum, layout, 0)

    1 <<< 28 ||| type <<< 24 ||| order <<< 20 ||| layout <<< 16 ||| bits <<< 8 ||| bytes <<< 0
  end

  def sdl_define_pixelfourcc(a, b, c, d) do
    a <<< 0 ||| b <<< 8 ||| c <<< 16 ||| d <<< 24
  end
end
