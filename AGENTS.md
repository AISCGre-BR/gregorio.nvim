# AGENTS.md — AI Code Generation Guide for gregorio.nvim

This document is the primary reference for AI agents (GitHub Copilot, Claude, etc.)
contributing code to this repository.

> **Language policy**: All human-readable content in this repository must be in English
> (source identifiers, comments, docs, commit messages, and error messages).

## 1. Project Overview

`gregorio.nvim` is a Neovim plugin that provides support for Gregorio
**GABC/NABC** files by integrating:

- [`tree-sitter-gregorio`](https://github.com/AISCGre-BR/tree-sitter-gregorio)
- [`gregorio-lsp`](https://github.com/AISCGre-BR/gregorio-lsp)

The plugin must keep a fallback static syntax highlighter for setups where
Tree-sitter is unavailable.

## 2. Repository Structure

```
AGENTS.md               ← This guide for AI coding agents
CHANGELOG.md            ← Release notes
README.md               ← User-facing documentation

plugin/gregorio.lua     ← Startup entrypoint
ftdetect/gabc.lua       ← Filetype detection
ftplugin/gabc.lua       ← Buffer-local GABC settings and syntax fallback
syntax/gabc.vim         ← Static Vim syntax fallback

lua/gregorio/
  init.lua              ← Setup, Tree-sitter and LSP wiring, user commands
  commands.lua          ← GABC editing commands (transpose/fill)
```

## 3. Development Rules

1. Keep changes focused and minimal.
2. Do not remove Tree-sitter or LSP integration paths.
3. Preserve fallback static syntax behavior.
4. Keep command names stable:
   - `GabcTransposeUp`
   - `GabcTransposeDown`
   - `GabcFillParens`
5. Update `CHANGELOG.md` and `README.md` when functionality changes.

## 4. Validation

There is currently no dedicated automated test suite in this repository.
Validate changes manually with headless Neovim command execution and by opening a
`.gabc` buffer to verify command behavior, highlighting fallback, and LSP startup.
