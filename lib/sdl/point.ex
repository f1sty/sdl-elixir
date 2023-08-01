defmodule Sdl.Point do
  defstruct x: 0, y: 0, ref: nil

  def new(nil), do: nil

  def new(config) do
    Map.merge(%__MODULE__{}, config)
  end
end

defmodule Sdl.FPoint do
  defstruct x: 0.0, y: 0.0, ref: nil

  def new(nil), do: nil

  def new(config) do
    Map.merge(%__MODULE__{}, config)
  end
end
