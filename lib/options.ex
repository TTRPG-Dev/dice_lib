defmodule DiceLib.Options do
  @moduledoc """
  Defines what options are available and how they are applied to roll results
  """

  @doc """
  Apply all provided options to the roll result

  ## Examples
    iex> DiceLib.Options.apply_options([1, 2, 3], %{})
    [1, 2, 3]

    iex> DiceLib.Options.apply_options([1, 2, 3], %{die_mod: 5})
    [6, 7, 8]
  """
  def apply_options(results, options) when map_size(options) == 0, do: results
  def apply_options(results, options) do
    results
    |> die_mod(options[:die_mod])
  end

  @doc """
  Apply the specified die_mod to each roll in the roll result

  ## Examples

    iex> DiceLib.Options.die_mod([1, 2, 3], 5)
    [6, 7, 8]

    iex> DiceLib.Options.die_mod([1, 2, 3], -5)
    [-4, -3, -2]
  """
  def die_mod(results, nil), do: results
  def die_mod(results, die_mod) do
    Enum.map(results, fn roll_result -> roll_result + die_mod end)
  end

end
