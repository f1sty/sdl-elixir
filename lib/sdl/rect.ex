defmodule Sdl.Rect do
  defstruct x: 0, y: 0, w: 0, h: 0, ref: nil

  def new(nil), do: nil

  def new(config) do
    Map.merge(%__MODULE__{}, config)
  end
end

defmodule Sdl.FRect do
  defstruct x: 0.0, y: 0.0, w: 0.0, h: 0.0, ref: nil

  def new(nil), do: nil

  def new(config) do
    Map.merge(%__MODULE__{}, config)
  end
end
