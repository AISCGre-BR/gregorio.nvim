# gregorio.nvim

Neovim plugin for **GABC/NABC** (Gregorio) files.

It integrates:

- [tree-sitter-gregorio](https://github.com/AISCGre-BR/tree-sitter-gregorio) for Tree-sitter parsing/highlighting when available;
- static Vim syntax highlighting as fallback;
- [gregorio-lsp](https://github.com/AISCGre-BR/gregorio-lsp) for diagnostics and language features.

## Features

- GABC filetype detection (`*.gabc`)
- Tree-sitter language registration for `gregorio`
- Static syntax highlighting fallback (`syntax/gabc.vim`)
- Automatic LSP startup with `gregorio-lsp` for `gabc` buffers
- Editing commands (ported from `gregorio.nvim-old` and adapted to current architecture):
  - `:GabcTransposeUp`
  - `:GabcTransposeDown`
  - `:GabcFillParens`
  - `:GabcConvertLigaturesToTags`
  - `:GabcConvertTagsToLigatures`
- Reusable resources imported from `gregorio.nvim-old`:
  - `snippets/gabc.snippets`
  - `templates/basic_gabc_template.gabc`
  - `templates/nabc_gabc_template.gabc`
  - `templates/advanced_gabc_template.gabc`

## Requirements

- Neovim 0.9+
- Optional for Tree-sitter features: `nvim-treesitter` + installed `gregorio` parser
- Optional for LSP features: `gregorio-lsp` in `$PATH`

Install `gregorio-lsp`:

```sh
cargo install --git https://github.com/AISCGre-BR/gregorio-lsp --tag v0.7.0 --bin gregorio-lsp
```

## Installation

### lazy.nvim

```lua
{
  "AISCGre-BR/gregorio.nvim",
  ft = "gabc",
}
```

### packer.nvim

```lua
use {
  "AISCGre-BR/gregorio.nvim",
  ft = "gabc",
}
```

## Configuration

Default setup is automatic via `plugin/gregorio.lua`.

Optional manual setup:

```lua
require("gregorio").setup({
  treesitter = {
    enabled = true,
    language = "gregorio",
  },
  lsp = {
    enabled = true,
    cmd = { "gregorio-lsp" },
  },
  keymaps = {
    enabled = true,             -- set to false to disable all keymaps
    transpose_up   = "<LocalLeader>tu",
    transpose_down = "<LocalLeader>td",
    fill_parens    = "<LocalLeader>fp",
    convert_ligatures_to_tags = "<LocalLeader>lt",
    convert_tags_to_ligatures = "<LocalLeader>tl",
  },
})
```

Set any individual key to `false` to disable only that mapping.

## Commands

| Command | Description |
|---|---|
| `:GabcTransposeUp` | Transpose notes in notation groups upward |
| `:GabcTransposeDown` | Transpose notes in notation groups downward |
| `:GabcFillParens` | Fill empty note groups with the last preceding pitch |
| `:GabcConvertLigaturesToTags` | Convert `æ`, `ǽ`, `œ` to `<sp>` tags in chant body |
| `:GabcConvertTagsToLigatures` | Convert `<sp>` ligature tags back to Unicode ligatures |

## Keymaps

Buffer-local keymaps are set automatically for `gabc` files (normal and visual mode where applicable):

| Key | Command | Modes |
|---|---|---|
| `<LocalLeader>tu` | `GabcTransposeUp` | `n`, `x` |
| `<LocalLeader>td` | `GabcTransposeDown` | `n`, `x` |
| `<LocalLeader>fp` | `GabcFillParens` | `n`, `x` |
| `<LocalLeader>lt` | `GabcConvertLigaturesToTags` | `n` |
| `<LocalLeader>tl` | `GabcConvertTagsToLigatures` | `n` |

All keymaps can be overridden or disabled via `setup()` (see [Configuration](#configuration)).

### Command behavior details

- **Range awareness** (`GabcTransposeUp`, `GabcTransposeDown`, `GabcFillParens`):
  when called without an explicit range or visual selection, the command operates on the
  **entire chant body** (all lines after `%%`). When a range or visual selection is
  given, only the selected lines are affected. Header lines are never modified.
- **Transpose scope**: only note letters inside notation groups `(...)` are shifted;
  bracketed fragments `[...]` inside groups are preserved.
  Accidentals (`gx`, `hy`, `i#`) and explicit custos (`f+`, `g+`) are handled correctly:
  the base pitch letter is transposed while the modifier character is preserved.
- **NABC awareness**: when the `nabc-lines` header is present, `GabcTransposeUp` and
  `GabcTransposeDown` only transpose the GABC segments inside mixed note groups.
  Pipe-separated segment at index `i` is GABC when `i % (nabc-lines + 1) == 0`.
  Example with `nabc-lines: 2`: in `(AAAA|BBBB|CCCC|DDDD|EEEE|FFFF)`, only `AAAA`
  and `DDDD` are transposed.
- **Fill parens**: `GabcFillParens` fills each empty group (`()` or `( )`) with the
  last pitch letter of the nearest preceding non-empty group, tracking state across
  the entire selected region or body.
  Example: `(fgh) () () () (ij) () ()` → `(fgh) (h) (h) (h) (ij) (j) (j)`.
- Ligature conversion commands always operate on the whole chant body.

## Snippets and templates

This repository also provides reusable resources imported from `gregorio.nvim-old`:

- Snippet pack: `snippets/gabc.snippets` (SnipMate/UltiSnips format)
- Starter templates:
  - `templates/basic_gabc_template.gabc`
  - `templates/nabc_gabc_template.gabc`
  - `templates/advanced_gabc_template.gabc`

The snippet pack includes:

- liturgical response shortcuts (`A/`, `R/`, `V/`)
- common lyric formatting tags (`<b>`, `<i>`, `<sc>`, `<ul>`, `<tt>`)
- control tags (`<clear>`, `<e>`, `<eu>`, `<nlba>`, `<sp>`, `<v>`, `<alt>`)
- header boilerplates (`gabcheader`, `nabcheader`)
- common neume and division helpers

## Notes about highlighting

When Tree-sitter support is available, the plugin registers `gregorio` for `gabc` files.
If Tree-sitter is unavailable, Neovim uses the static fallback in `syntax/gabc.vim`.

The static fallback is the comprehensive port from `gregorio.nvim-old` and includes:

- structured header highlighting (`key: value;`, numeric and LaTeX-enabled headers)
- full GABC note-section tokens (pitches, bars, custos, spacing, and inline chant tags)
- NABC notation support (St. Gall/Laon code families and modifiers)
- error highlighting for invalid GABC/NABC snippets

## License

MIT — Copyright (c) 2026 AISCGre Brasil.

## References / Related projects

- [zed-gregorio](https://github.com/AISCGre-BR/zed-gregorio)
