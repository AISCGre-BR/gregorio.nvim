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
- Editing commands:
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
| `:GabcTransposeUp` | Transpose notes in notation groups upward |
| `:GabcTransposeDown` | Transpose notes in notation groups downward |
| `:GabcFillParens` | Replace empty groups like `()` with `(f)` |
| `:GabcConvertLigaturesToTags` | Convert `æ`, `ǽ`, `œ` to `<sp>` tags in chant body |
| `:GabcConvertTagsToLigatures` | Convert `<sp>` ligature tags back to Unicode ligatures |

## Snippets and templates

This repository also provides reusable resources imported from `gregorio.nvim-old`:

- Snippet pack: `snippets/gabc.snippets` (SnipMate/UltiSnips format)
- Starter templates:
  - `templates/basic_gabc_template.gabc`
  - `templates/nabc_gabc_template.gabc`
  - `templates/advanced_gabc_template.gabc`

## Notes about highlighting

When Tree-sitter support is available, the plugin registers `gregorio` for `gabc` files.
If Tree-sitter is unavailable, Neovim uses the static fallback in `syntax/gabc.vim`.

## License

MIT — Copyright (c) 2026 AISCGre Brasil.

## References / Related projects

- [zed-gregorio](https://github.com/AISCGre-BR/zed-gregorio)
