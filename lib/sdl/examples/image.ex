defmodule Sdl.Examples.Image do
  @moduledoc false

  import Sdl
  alias Sdl.Event

  require Logger

  def run(
        path,
        title \\ "main window",
        x \\ :sdl_windowpos_centered,
        y \\ :sdl_windowpos_centered,
        w \\ 600,
        h \\ 400,
        flags \\ [:sdl_window_shown]
      ) do
    # sdl_init([:sdl_init_everything])
    sdl_init([:sdl_init_video])

    driver_name = sdl_get_video_driver(0)
    Logger.info("using #{driver_name} video_driver")

    window = sdl_create_window(title, x, y, w, h, flags)
    renderer = sdl_create_renderer(window, -1, [:sdl_renderer_accelerated])
    surface = img_load(path)
    texture = sdl_create_texture_from_surface(renderer, surface)

    sdl_free_surface(surface)
    delay = from_fps(60)

    loop(window, renderer, texture, delay, false)
  end

  def loop(window, renderer, texture, _delay, true) do
    Logger.info("closing window, bye-bye!")
    sdl_destroy_texture(texture)
    sdl_destroy_renderer(renderer)
    sdl_destroy_window(window)
    sdl_quit()
  end

  def loop(window, renderer, texture, delay, false) do
    quit? =
      case sdl_poll_event() do
        %Event{type: :sdl_quit} ->
          true

        %Event{type: :sdl_keydown, key: key_event} ->
          IO.inspect(key_event.keysym.scancode, label: :scancode)
          false

        _event ->
          false
      end

    sdl_render_clear(renderer)
    sdl_render_copy(renderer, texture, nil, nil)
    sdl_render_present(renderer)
    sdl_delay(delay)
    loop(window, renderer, texture, delay, quit?)
  end

  def from_fps(fps), do: div(1000, fps)
end
