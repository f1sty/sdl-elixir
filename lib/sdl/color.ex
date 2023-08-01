defmodule Sdl.Colour do
  defstruct r: 0, g: 0, b: 0, a: 0, ref: nil

  def new(nil), do: nil

  def new(config) do
    Map.merge(%__MODULE__{}, config)
  end
end

defmodule Sdl.Color do
  defstruct r: 0, g: 0, b: 0, a: 0, ref: nil

  def new(nil), do: nil

  def new(config) do
    Map.merge(%__MODULE__{}, config)
  end
end
