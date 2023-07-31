defmodule Sdl do
  @moduledoc """
  Implements functions from `SDL.h`
  """
  @on_load :init_nifs
  def init_nifs, do: :erlang.load_nif(~c"c_src/sdl_nif", 0)

  import Sdl.Helpers

  def sdl_init_nif(_flags) do
    nif_not_loaded!()
  end

  def sdl_init_sub_system_nif(_flags) do
    nif_not_loaded!()
  end

  def sdl_quit_nif() do
    nif_not_loaded!()
  end

  def sdl_quit_sub_system_nif(_flags) do
    nif_not_loaded!()
  end

  def sdl_was_init_nif(_flags) do
    nif_not_loaded!()
  end

  def sdl_init(flags) do
    flags |> from_list() |> sdl_init_nif()
  end

  def sdl_init_sub_system(flags) do
    flags |> from_list() |> sdl_init_sub_system_nif()
  end

  def sdl_quit do
    sdl_quit_nif()
  end

  def sdl_quit_sub_system(flags) do
    flags |> from_list() |> sdl_quit_sub_system_nif()
  end

  def sdl_was_init_nif(flags) do
    flags |> from_list() |> sdl_was_init_nif()
  end
end
