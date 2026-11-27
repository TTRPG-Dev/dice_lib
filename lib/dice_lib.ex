defmodule DiceLib do
  @moduledoc """
  This module, and it's def, are meant as the primary entrypoint into the library.
  """
  alias DiceLib.Basic
  alias DiceLib.Options

  @doc """
  The primary roll function

  ## Examples

      # Although not necessary, let's seed the random algorithm
      iex> :rand.seed(:exsplus, 1337)
      iex> DiceLib.roll("3d8")
      [4, 8, 5]

      iex> :rand.seed(:exsplus, 1337)
      iex> DiceLib.roll("3d8", %{die_mod: 2})
      [6, 10, 7]

      iex> :rand.seed(:exsplus, 1337)
      iex> DiceLib.roll("3d8", %{die_mod: 2, drop_lowest: 1})
      [10, 7]

      iex> DiceLib.roll("bad_input")
      ** (RuntimeError) Improper dice format. Dice must be given in xdy where x and y are both integers
  """
  def roll(spec), do: Basic.roll(spec)
  def roll(spec, options) do
    Basic.roll(spec)
    |> Options.apply_options(options)
  end
end
