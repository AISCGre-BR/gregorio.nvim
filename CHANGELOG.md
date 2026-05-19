# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

## [0.3.0] - 2026-05-19

### Fixed

- `setup_treesitter()` no longer crashes on nvim-treesitter ≥ 1.0, which
  removed `parsers.get_parser_configs()`. The call is now guarded with
  `type(parsers.get_parser_configs) == "function"` so that on older versions
  `:TSInstall gregorio` still works, while on newer versions the block is
  silently skipped. Runtime treesitter support (syntax highlighting via
  `vim.treesitter.language.register`) is unaffected on all versions.

## [0.2.0] - 2026-05-18

### Changed

- `GabcTransposeUp`, `GabcTransposeDown`, and `GabcFillParens` now operate on the
  **entire chant body** when called without an explicit range or visual selection.
  When a range or visual selection is given, only the selected lines are affected.
- `GabcFillParens` now fills each empty note group `()` with the **last pitch letter
  of the nearest preceding non-empty note group**, tracking state across the entire
  selected region or body. Example: `(fgh) () () (ij) () ()` →
  `(fgh) (h) (h) (ij) (j) (j)`.
- `GabcTransposeUp` and `GabcTransposeDown` now correctly skip **NABC segments** in
  mixed GABC/NABC note groups, reading the `nabc-lines` header to determine which
  pipe-separated segments are GABC. With `nabc-lines: N`, segment at pipe-index `i`
  is GABC when `i % (N + 1) == 0`. Example with `nabc-lines: 2`:
  `(AAAA|BBBB|CCCC|DDDD|EEEE|FFFF)` → only `AAAA` and `DDDD` are transposed.
- `GabcTransposeUp` and `GabcTransposeDown` correctly transpose **accidentals**
  (`gx`, `hy`, `i#`) and **explicit custos** (`f+`, `g+`): the base note letter is
  shifted while the modifier character (`x`, `y`, `#`, `+`) is preserved.

## [0.1.0] - 2026-05-18

### Added

- Initial Neovim plugin scaffolding for GABC/NABC support.
- Tree-sitter integration path for `tree-sitter-gregorio`.
- Static Vim syntax fallback for GABC.
- Automatic `gregorio-lsp` startup for `gabc` buffers.
- Editing commands:
  - `:GabcTransposeUp`
  - `:GabcTransposeDown`
  - `:GabcFillParens`
  - `:GabcConvertLigaturesToTags` (converts `æ`, `ǽ`, `œ` to `<sp>` tags in chant body)
  - `:GabcConvertTagsToLigatures` (converts `<sp>` ligature tags back to Unicode ligatures)
- Buffer-local keymaps for all editing commands, active in `gabc` buffers:
  - `<LocalLeader>tu` → `GabcTransposeUp` (normal + visual)
  - `<LocalLeader>td` → `GabcTransposeDown` (normal + visual)
  - `<LocalLeader>fp` → `GabcFillParens` (normal + visual)
  - `<LocalLeader>lt` → `GabcConvertLigaturesToTags` (normal)
  - `<LocalLeader>tl` → `GabcConvertTagsToLigatures` (normal)
  - Configurable via `keymaps` table in `setup()`; set `enabled = false` to disable all,
    or set individual keys to `false` to disable specific mappings.
- Snippet pack at `snippets/gabc.snippets` (SnipMate/UltiSnips format)
- Reusable template files:
  - `templates/basic_gabc_template.gabc`
  - `templates/nabc_gabc_template.gabc`
  - `templates/advanced_gabc_template.gabc`

### Changed

- Replaced the minimal static syntax fallback (`syntax/gabc.vim`) with a
  comprehensive implementation ported from `gregorio.nvim-old` (v2.1):
  - Header section: field, colon, value, and semicolon highlighting; numeric
    headers (`mode`, `staff-lines`, `initial-style`) with `Number` highlight;
    `def-m0`–`def-m9` macro headers; LaTeX-enabled headers
    (`name`, `annotation`, `commentary`, `office-part`, `transcriber`,
    `user-notes`, `bibliography`, `mode-differentia`, `mode-modifier`) with
    embedded `@texSyntax` support.
  - Note section: full GABC pitch, accidental, pitch-modifier, bar, custos,
    line-break, neume-fusion, and neume-spacing highlighting; XML-like inline
    lyric tags (`<b>`, `<i>`, `<ul>`, `<sc>`, `<tt>`, `<e>`, `<eu>`, `<alt>`,
    `<sp>`, `<v>`, `<pr>`, `<nlba>`, `<clear>`).
  - NABC support: neume codes (St. Gall and Laon families), glyph modifiers,
    pitch descriptors, subpunctis/prepunctis descriptors, significant letters,
    Tironian letters, horizontal spacing adjustment.
  - Error highlighting for invalid characters in GABC/NABC snippets.
  - Embedded LaTeX syntax (`@texSyntax`) inside `<v>` verbatim tags.
- Improved `README.md` documentation:
  - Documented detailed command scope and range behavior in chant body (`%%` separator).
  - Expanded fallback highlighting coverage notes for GABC/NABC support.
  - Expanded snippets/templates documentation with practical resource categories.
  - Added keymaps reference table and configuration examples.
