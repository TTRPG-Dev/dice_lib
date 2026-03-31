defmodule DiceLibTest do
  use ExUnit.Case
  doctest DiceLib

  test "greets the world" do
    assert DiceLib.hello() == :world
  end
end
