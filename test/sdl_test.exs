defmodule SdlTest do
  use ExUnit.Case
  doctest Sdl

  test "greets the world" do
    assert Sdl.hello() == :world
  end
end
