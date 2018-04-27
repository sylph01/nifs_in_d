defmodule Sha3 do
  @on_load :load_nifs
  
  def load_nifs do
    :erlang.load_nif('./native_obj/sha3', 0)
  end
  
  def sha3_256(_str) do
    raise "NIF sha3_256/1 not implemented"
  end
end
