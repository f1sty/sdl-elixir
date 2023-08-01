defmodule Sdl.KeyboardEvent do
  alias Sdl.Keysym

  defstruct ~w[type timestamp window_id state repeat padding2 padding3 keysym]a

  def new(nil), do: nil

  def new(%{keysym: keysym} = config) do
    config = %{config | keysym: Keysym.new(keysym)}
    Map.merge(%__MODULE__{}, config)
  end
end
