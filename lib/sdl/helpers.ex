defmodule Sdl.Helpers do
  @moduledoc """
  Helper functions for other modules.
  """

  import Bitwise

  @flags_mappings %{
    sdl_init_timer: 0x00000001,
    sdl_init_audio: 0x00000010,
    sdl_init_video: 0x00000020,
    sdl_init_joystick: 0x00000200,
    sdl_init_haptic: 0x00001000,
    sdl_init_gamecontroller: 0x00002000,
    sdl_init_events: 0x00004000,
    sdl_init_sensor: 0x00008000,
    sdl_init_noparachute: 0x00100000,
    sdl_init_everything:
      0x00000001 |||
        0x00000010 |||
        0x00000020 |||
        0x00004000 |||
        0x00000200 |||
        0x00001000 |||
        0x00002000 |||
        0x00008000
  }

  defmodule NifNotLoaded do
    defexception [:message]
  end

  def nif_not_loaded! do
    raise NifNotLoaded, message: "could not load c_src/sdl_nif.so"
  end

  def from_list(flags) do
    Enum.reduce(flags, 0, fn flag, acc -> bor(acc, @flags_mappings[flag]) end)
  end
end
