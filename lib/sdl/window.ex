defmodule Sdl.Window do
  defstruct [:ref]

  def new(nil), do: nil

  def new(config) do
    Map.merge(%__MODULE__{}, config)
  end
end
