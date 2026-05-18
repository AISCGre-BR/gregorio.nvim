# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

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
