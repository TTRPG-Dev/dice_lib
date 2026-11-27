defmodule DiceLib.Parsing do
  @dice_regex ~r/^([0-9]+)d([0-9]+)$/

  @doc """
  Validates that a given string conforms to the expexted dice specifying format

  Returns: the input string

  ## Examples

      iex> DiceLib.Parsing.validate_dice_str("3d4")
      "3d4"

      iex> DiceLib.Parsing.validate_dice_str("3")
      ** (RuntimeError) Improper dice format. Dice must be given in xdy where x and y are both integers

  """
  def validate_dice_str(str) do
    if not Regex.match?(@dice_regex, str) do
      raise "Improper dice format. Dice must be given in xdy where x and y are both integers"
    end

    str
  end

  @doc """
  Tries to parse a given dice spec string into it's component parts

  Returns: a tuple where the first item is the number of times to roll the die and the second indicates the  number or sides the die has

  ## Examples

      iex> DiceLib.Parsing.parse_roll_spec!("3d4")
      {3, 4}

      iex> DiceLib.Parsing.parse_roll_spec!("3")
      ** (RuntimeError) Improper dice format. Dice must be given in xdy where x and y are both integers

  """

  def parse_roll_spec!(roll_spec) when is_bitstring(roll_spec) do
    roll_spec
    |> validate_dice_str()
    |> String.split("d")
    |> Enum.map(fn x -> String.to_integer(x) end)
    |> List.to_tuple()
  end
end
