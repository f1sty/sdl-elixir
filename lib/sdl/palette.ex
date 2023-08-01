defmodule Sdl.Palette do
  alias Sdl.Color

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
