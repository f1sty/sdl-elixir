defmodule Sdl.RWops do
  defstruct [:type, :hidden, :ref]

  def new(nil), do: nil

  def new(config) do
    Map.merge(%__MODULE__{}, config)
  end

  def size(_rw_ops), do: 0
  def seek(_rw_ops, _offset, _whence), do: 0
  def read(_rw_ops, _ptr, _size, _maxnum), do: 0
  def write(_rw_ops, _ptr, _size, _num), do: 0
  def close(_rw_ops), do: 0
end
