defmodule Sdl.QuitEvent do
  defstruct ~w[type timestamp]a

  def new(nil), do: nil

  def new(config) do
    Map.merge(%__MODULE__{}, config)
  end
end
