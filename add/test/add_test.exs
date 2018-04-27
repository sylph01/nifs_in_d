defmodule AddTest do
  use ExUnit.Case
  doctest Add

  test "greets the world" do
    assert Add.hello() == :world
  end
end
