defmodule DiceLib do
  @moduledoc """
  This module, and it's def, are meant as the primary entrypoint into the library.
  """
  alias DiceLib.Basic

  @doc """
  The primary roll function.
  """
  def roll(spec) do
    Basic.roll(spec)
  end
end
