# Architecture

## Overview

`dice_lib` is a small, single-concern Elixir library for rolling tabletop RPG dice. It is intended to be published to [Hex.pm](https://hex.pm) and consumed as a dependency by other TTRPG Elixir projects.

## Module Structure

```
lib/
└── basic.ex          # DiceLib.Basic — all current rolling logic
test/
└── basic_test.exs    # ExUnit tests; delegates to doctests in DiceLib.Basic
```

The top-level namespace is `DiceLib`. Currently there is one module:

### `DiceLib.Basic`

All dice-rolling functionality lives here. The public API has a clear pipeline shape:

```
string input
    └─► validate_dice_str/1   — regex guard ("NdM" format)
    └─► parse_roll_spec!/1    — splits into {count, sides} tuple
    └─► roll/1, roll/2        — dispatches to roll_d/1 for each die
    └─► roll_d/1              — single die roll via :rand.uniform/1
```

Public functions:

| Function | Input | Output |
|---|---|---|
| `validate_dice_str/1` | `"NdM"` string | same string or raises |
| `parse_roll_spec!/1` | `"NdM"` string | `{count, sides}` tuple |
| `roll/1` | string, tuple, or `{count, sides}` | `[integer]` |
| `roll/2` | `count, sides` integers | `[integer]` |
| `multi_roll!/1` | list of strings or tuples | `[{spec, [integer]}]` |
| `roll_d/1` | sides integer | integer |

## Testing Strategy

- `ExUnit` with `async: true`
- Tests are primarily **doctests** embedded in `@doc` blocks in `DiceLib.Basic`
- Doctests seed `:rand` with `:exsplus` + a fixed value to produce deterministic results
- No mocking; randomness is controlled via seeding

## Dependencies

| Dep | Purpose | Env |
|---|---|---|
| `ex_doc` | Documentation generation for Hex publish | `:dev` only |

## Dice Notation

Currently supports basic common dice notation: `NdM` where `N` is the number of dice and `M` is the number of sides (e.g. `"3d8"`, `"1d20"`). Modifiers (e.g. `+2`, advantage/disadvantage, drop-lowest) are not yet implemented.
