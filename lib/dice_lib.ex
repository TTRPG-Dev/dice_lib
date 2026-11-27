defmodule DiceLib do
  @moduledoc """
  This module, and it's def, are meant as the primary entrypoint into the library.
  """
  alias DiceLib.Basic
  alias DiceLib.Options
  alias DiceLib.Parsing

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

      iex> :rand.seed(:exsplus, 1337)
      iex> DiceLib.roll("3d8", %{reroll: 8})
      [4, 1, 5]

      iex> DiceLib.roll("bad_input")
      ** (RuntimeError) Improper dice format. Dice must be given in xdy where x and y are both integers
  """
  def roll(spec), do: Basic.roll(spec)
  def roll(spec, options) do
    die_spec = to_die_spec(spec)

    Basic.roll(die_spec)
    |> Options.apply_options(die_spec, options)
  end

  defp to_die_spec({_number_of_dice, _sides} = die_spec), do: die_spec
  defp to_die_spec(spec) when is_bitstring(spec), do: Parsing.parse_roll_spec!(spec)
end
