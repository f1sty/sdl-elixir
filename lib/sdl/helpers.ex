defmodule Sdl.Helpers do
  @moduledoc """
  Helper functions for other modules.
  """

  import Bitwise

  def pixel_format_enum() do
    %{
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
  end

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

  def sdl_define_pixelformat(type, order, layout, bits, bytes) do
    type = Map.get(@pixel_type_enum, type, 0)
    order = Map.get(@packed_order_enum, order, 0)
    layout = Map.get(@packed_layout_enum, layout, 0)

    1 <<< 28 ||| type <<< 24 ||| order <<< 20 ||| layout <<< 16 ||| bits <<< 8 ||| bytes <<< 0
  end

  def sdl_define_pixelfourcc(a, b, c, d) do
    a <<< 0 ||| b <<< 8 ||| c <<< 16 ||| d <<< 24
  end

  def int_to_enum_values(blend_mode, enum) do
    Enum.reject(enum, fn {_k, v} -> (v &&& blend_mode) == 0 end) |> Keyword.keys()
  end

  def int_to_enum_value(int, enum) do
    Enum.find_value(enum, fn {k, v} -> v == int && k end)
  end

  defmodule NifNotLoaded do
    defexception [:message]
  end

  def nif_not_loaded! do
    raise NifNotLoaded, message: "could not load c_src/sdl_nif.so"
  end

  def from_list(flags, mappings) do
    Enum.reduce(flags, 0, fn flag, acc -> bor(acc, mappings[flag]) end)
  end
end
