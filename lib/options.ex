defmodule DiceLib.Options do
  @moduledoc """
  Defines what options are available and how they are applied to roll results
  """

  @doc """
  Apply all provided options to the roll result

  `die_spec` is the parsed `{number_of_dice, sides}` the results were rolled
  from, for options that need to know about the dice themselves

  ## Examples
    iex> DiceLib.Options.apply_options([1, 2, 3], {3, 6}, %{})
    [1, 2, 3]

    iex> DiceLib.Options.apply_options([1, 2, 3], {3, 6}, %{die_mod: 5})
    [6, 7, 8]
  """
  def apply_options(results, _die_spec, options) when map_size(options) == 0, do: results
  def apply_options(results, _die_spec, options) do
    results
    |> die_mod(options[:die_mod])
    |> drop_lowest(options[:drop_lowest])
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

  @doc """
  Drops the lowest x number of rolls from the result, keeping the
  remaining rolls in the order they were rolled

  ## Examples

    iex> DiceLib.Options.drop_lowest([8, 3, 7, 2], 2)
    [8, 7]

    iex> DiceLib.Options.drop_lowest([2, 5, 2, 4], 1)
    [5, 2, 4]
  """
  def drop_lowest(results, nil), do: results
  def drop_lowest(results, lowest) when is_integer(lowest) do
    # `--` removes only the first occurrence of each element, so duplicate
    # values are dropped no more times than requested
    results -- Enum.take(Enum.sort(results), lowest)
  end

end
