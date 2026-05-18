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
})
```

## Commands

| Command | Description |
|---|---|
| `:GabcTransposeUp` | Transpose notes in notation groups upward (supports ranges) |
| `:GabcTransposeDown` | Transpose notes in notation groups downward (supports ranges) |
| `:GabcFillParens` | Replace empty groups like `()` with `(f)` (supports ranges) |
| `:GabcConvertLigaturesToTags` | Convert `æ`, `ǽ`, `œ` to `<sp>` tags in chant body |
| `:GabcConvertTagsToLigatures` | Convert `<sp>` ligature tags back to Unicode ligatures |

### Command behavior details

- Range-aware commands (`GabcTransposeUp`, `GabcTransposeDown`, `GabcFillParens`) only modify the chant body section, i.e. lines after the `%%` header/body separator.
- `GabcTransposeUp` and `GabcTransposeDown` only transpose note letters inside note groups `(...)`; bracketed fragments `[...]` inside groups are preserved.
- `GabcFillParens` turns empty or whitespace-only groups (`()`, `(   )`) into `(f)`.
- Ligature conversion commands operate on the whole chant body and keep headers untouched.

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
