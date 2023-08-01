defmodule Sdl.Event do
  alias Sdl.KeyboardEvent
  alias Sdl.QuitEvent

  import Sdl.Helpers

  @even_type_enum %{
    sdl_firstevent: 0,
    sdl_quit: 0x100,
    sdl_app_terminating: 0x101,
    sdl_app_lowmemory: 0x102,
    sdl_app_willenterbackground: 0x103,
    sdl_app_didenterbackground: 0x104,
    sdl_app_willenterforeground: 0x105,
    sdl_app_didenterforeground: 0x106,
    sdl_localechanged: 0x106,
    sdl_displayevent: 0x150,
    sdl_windowevent: 0x200,
    sdl_syswmevent: 0x201,
    sdl_keydown: 0x300,
    sdl_keyup: 0x301,
    sdl_textediting: 0x302,
    sdl_textinput: 0x303,
    sdl_keymapchanged: 0x304,
    sdl_textediting_ext: 0x305,
    sdl_mousemotion: 0x400,
    sdl_mousebuttondown: 0x401,
    sdl_mousebuttonup: 0x402,
    sdl_mousewheel: 0x403,
    sdl_joyaxismotion: 0x600,
    sdl_joyballmotion: 0x601,
    sdl_joyhatmotion: 0x602,
    sdl_joybuttondown: 0x603,
    sdl_joybuttonup: 0x604,
    sdl_joydeviceadded: 0x605,
    sdl_joydeviceremoved: 0x606,
    sdl_joybatteryupdated: 0x607,
    sdl_controlleraxismotion: 0x650,
    sdl_controllerbuttondown: 0x651,
    sdl_controllerbuttonup: 0x652,
    sdl_controllerdeviceadded: 0x653,
    sdl_controllerdeviceremoved: 0x654,
    sdl_controllerdeviceremapped: 0x655,
    sdl_controllertouchpaddown: 0x656,
    sdl_controllertouchpadmotion: 0x657,
    sdl_controllertouchpadup: 0x658,
    sdl_controllersensorupdate: 0x659,
    sdl_fingerdown: 0x700,
    sdl_fingerup: 0x701,
    sdl_fingermotion: 0x702,
    sdl_dollargesture: 0x800,
    sdl_dollarrecord: 0x801,
    sdl_multigesture: 0x802,
    sdl_clipboardupdate: 0x900,
    sdl_dropfile: 0x1000,
    sdl_droptext: 0x1001,
    sdl_dropbegin: 0x1002,
    sdl_dropcomplete: 0x1003,
    sdl_audiodeviceadded: 0x1100,
    sdl_audiodeviceremoved: 0x1101,
    sdl_sensorupdate: 0x1200,
    sdl_render_targets_reset: 0x2000,
    sdl_render_device_reset: 0x2001,
    sdl_pollsentinel: 0x7F00,
    sdl_userevent: 0x8000,
    sdl_lastevent: 0xFFFF
  }

  defstruct ~w[type common display window key edit edit_ext text motion button wheel jaxis jball jhat jbutton caxis cbutton cdevice ctouchpad csensor adevice sensor quit user syswm tfinger mgesture dgesture drop]a

  def new(nil), do: nil
 
  # Sdl.Event.new(%{type: 0x300, key: %{type: 0x300, timestamp: "date", keysym: %{scancode: 40}}})
  def new(%{type: type} = config) do
    type = int_to_enum_value(type, @even_type_enum)

    config =
      case type do
        :sdl_quit ->
          %{quit: quit_config} = config
          quit_config = %{quit_config | type: type}
          %{config | type: type, quit: QuitEvent.new(quit_config)}

        :sdl_keydown ->
          %{key: key_config} = config
          key_config = %{key_config | type: type}
          %{config | type: type, key: KeyboardEvent.new(key_config)}

        _ ->
          %{config | type: type}
      end

    Map.merge(%__MODULE__{}, config)
  end
end
