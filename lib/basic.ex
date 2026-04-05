defmodule DiceLib.Basic do
  alias DiceLib.Parsing
  @moduledoc """
  Basic rolling functionality
  """

  @doc """
  Rolls the a number of multisided dice

  Returns: List of die roll results

  ## Examples

      # Although not necessary, let's seed the random algorithm
      iex> :rand.seed(:exsplus, 1337)
      iex> DiceLib.Basic.roll(3, 8)
      [4, 8, 5]

      iex> :rand.seed(:exsplus, 1337)
      iex> DiceLib.Basic.roll({3, 8})
      [4, 8, 5]

      iex> :rand.seed(:exsplus, 1337)
      iex> DiceLib.Basic.roll("3d8")
      [4, 8, 5]

      iex> DiceLib.Basic.roll("bad_input")
      ** (RuntimeError) Improper dice format. Dice must be given in xdy where x and y are both integers

  """
  def roll(str) when is_bitstring(str) do
    {number_of_dice, sides} = Parsing.parse_roll_spec!(str)
    roll(number_of_dice, sides)
  end

  def roll({number_of_dice, sides}), do: roll(number_of_dice, sides)

  def roll(number_of_dice, dice_sides) do
    Enum.map(1..number_of_dice, fn _ -> roll_d(dice_sides) end)
  end

  @doc """
  Roll multiple roll specs

  Returns: List of tuples, the first value being the roll spec, the second being the results

  ## Examples
      # Although not necessary, let's seed the random algorithm
      iex> :rand.seed(:exsplus, 1337)
      iex> DiceLib.Basic.multi_roll!(["3d4", "4d8", "2d20"])
      [{"3d4", [4, 4, 1]}, {"4d8", [1, 3, 5, 6]}, {"2d20", [5, 12]}]

      iex> :rand.seed(:exsplus, 1337)
      iex> DiceLib.Basic.multi_roll!([{3, 4}, {4, 8}, {2, 20}])
      [{{3, 4}, [4, 4, 1]}, {{4, 8}, [1, 3, 5, 6]}, {{2, 20}, [5, 12]}]

      iex> DiceLib.Basic.multi_roll!(["bad_spec", "oh_no!", "3d4"])
      ** (RuntimeError) Improper dice format. Dice must be given in xdy where x and y are both integers

  """
  def multi_roll!(roll_specs) when is_list(roll_specs) do
    roll_specs
    |> Enum.map(fn roll_spec -> {roll_spec, roll(roll_spec)} end)
  end

  @doc """
  Rolls a die with the number of sides given in the input

  Returns: the rolled number

  ## Examples

      # Although not necessary, let's seed the random algorithm
      iex> :rand.seed(:exsplus, 1337)
      iex> DiceLib.Basic.roll_d(6)
      6
      iex> DiceLib.Basic.roll_d(6)
      2

  """
  def roll_d(sides) when is_integer(sides) do
    :rand.uniform(sides)
  end
end
