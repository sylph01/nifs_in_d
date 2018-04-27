defmodule Add do
  @on_load :load_nifs

  def load_nifs do
    :erlang.load_nif('./native_obj/add', 0)
  end

  def add(_a, _b) do
    raise "NIF add/2 not implemented"
  end
end
