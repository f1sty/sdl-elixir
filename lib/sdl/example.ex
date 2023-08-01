defmodule Sdl.Example do
  @moduledoc false

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
    Sdl.sdl_init([:sdl_init_everything])

    driver_name = Sdl.sdl_get_video_driver(0)
    Logger.info("using #{driver_name} video_driver")

    window = Sdl.sdl_create_window(title, x, y, w, h, flags)
    Logger.info("window opaque struct address: 0x#{Integer.to_string(window.ref, 16)}")

    renderer = Sdl.sdl_create_renderer(window, -1, [:sdl_renderer_accelerated])
    surface = Sdl.img_load(path)
    texture = Sdl.sdl_create_texture_from_surface(renderer, surface)

    Sdl.sdl_free_surface(surface)
    Sdl.sdl_query_texture(texture)
    Sdl.sdl_render_clear(renderer)
    Sdl.sdl_render_copy(renderer, texture, nil, nil)
    Sdl.sdl_render_present(renderer)

    pause = from_fps(60)

    loop(pause, renderer, texture, window)
  end

  def loop(pause, renderer, texture, window) do
    case Sdl.sdl_poll_event() do
      %Sdl.Event{type: :sdl_quit} ->
        Logger.info("closing window, bye-bye!")
        Sdl.sdl_destroy_texture(texture)
        Sdl.sdl_destroy_renderer(renderer)
        Sdl.sdl_destroy_window(window)
        Sdl.sdl_quit()

      %Sdl.Event{type: :sdl_keydown, key: key_event} ->
        IO.inspect(key_event, label: :key_event)
        Process.sleep(pause)
        loop(pause, renderer, texture, window)

      _event ->
        Process.sleep(pause)
        loop(pause, renderer, texture, window)
    end
  end

  def from_fps(fps), do: div(1000, fps)
end
