defmodule Sdl.PixelFormat do
  alias Sdl.Palette

  import Sdl.Helpers

  defstruct ~w[format palette bits_per_pixel bytes_per_pixel padding r_mask g_mask b_mask a_mask r_loss g_loss b_loss a_loss r_shift g_shift b_shift a_shift refcount next ref]a
  def new(nil), do: nil

  def new(%{format: format, palette: palette_config} = config) do
    format = int_to_enum_value(format, pixel_format_enum())
    config = %{config | palette: Palette.new(palette_config), format: format}
    Map.merge(%__MODULE__{}, config)
  end
end
