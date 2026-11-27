defmodule DiceLib.Options do
  alias DiceLib.Basic
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
  def apply_options(results, die_spec, options) do
    results
    |> reroll(die_spec, options[:reroll])
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

  @doc """
  Rerolls any die whose result is one of the given values, repeating until
  the die lands on a value not in the list. Rerolled dice stay in their
  original position.

  `reroll` may be a single value or a list of values. Raises if the list
  covers every face of the die, since the reroll could never end.

  ## Examples

    iex> :rand.seed(:exsplus, 1337)
    iex> DiceLib.Options.reroll([2, 8, 6], {3, 8}, 8)
    [2, 4, 6]

    # A reroll that lands on another listed value is rerolled again
    # (here the 8 rerolls into 4, then 8, then finally 5)
    iex> :rand.seed(:exsplus, 1337)
    iex> DiceLib.Options.reroll([1, 8, 6], {3, 8}, [4, 8])
    [1, 5, 6]

    iex> DiceLib.Options.reroll([1, 2], {2, 2}, [1, 2])
    ** (ArgumentError) cannot reroll every face of a d2: [1, 2]
  """
  def reroll(results, _die_spec, nil), do: results
  def reroll(results, die_spec, value) when is_integer(value), do: reroll(results, die_spec, [value])

  def reroll(results, {_number_of_dice, sides}, values) when is_list(values) do
    if Enum.all?(1..sides, &(&1 in values)) do
      raise ArgumentError, "cannot reroll every face of a d#{sides}: #{inspect(values)}"
    end

    Enum.map(results, &reroll_die(&1, sides, values))
  end

  defp reroll_die(result, sides, values) do
    if result in values do
      reroll_die(Basic.roll_d(sides), sides, values)
    else
      result
    end
  end
end
