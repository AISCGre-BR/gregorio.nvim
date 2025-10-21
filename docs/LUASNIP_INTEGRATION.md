# LuaSnip Integration Guide for gregorio.nvim

## Overview

This guide provides comprehensive instructions for using gregorio.nvim snippets with [LuaSnip](https://github.com/L3MON4D3/LuaSnip), a modern snippet engine for Neovim written in Lua.

## Why LuaSnip?

- **Native Lua implementation** - Fast and efficient
- **Dynamic snippets** - Powerful scripting capabilities
- **Choice nodes** - Interactive snippet navigation
- **VSCode snippet compatibility** - Easy migration
- **Active development** - Regular updates and improvements

## Installation

### Prerequisites

```lua
-- Using lazy.nvim
{
  'L3MON4D3/LuaSnip',
  version = 'v2.*',
  build = 'make install_jsregexp', -- Optional: for regex support
}

-- Using packer.nvim
use {
  'L3MON4D3/LuaSnip',
  tag = 'v2.*',
  run = 'make install_jsregexp',
}
```

### Recommended Plugins

```lua
-- For snippet autocompletion
use 'saadparwaiz1/cmp_luasnip'

-- For visual snippet insertion
use 'rafamadriz/friendly-snippets'
```

## Configuration

### Method 1: Loading from snippets/ directory (Recommended)

LuaSnip can automatically load SnipMate-format snippets from the `snippets/` directory.

```lua
-- In your init.lua or snippets.lua
local luasnip = require('luasnip')

-- Load snippets from all runtimepath directories
-- This includes gregorio.nvim/snippets/gabc.snippets
require('luasnip.loaders.from_snipmate').lazy_load()

-- Or load only from specific paths
require('luasnip.loaders.from_snipmate').lazy_load({
  paths = { '~/.config/nvim/pack/plugins/start/gregorio.nvim/snippets' }
})
```

### Method 2: Converting to LuaSnip format

For advanced features and customization, you can convert snippets to native LuaSnip format:

```lua
-- Create ~/.config/nvim/luasnippets/gabc.lua
local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local fmt = require('luasnip.extras.fmt').fmt

return {
  -- Antiphon Response
  s({ trig = "a/.", name = "Antiphon Response", dscr = "Inserts <sp>A/</sp>." }, {
    t("<sp>A/</sp>.")
  }),

  -- Colored Antiphon Response
  s({ trig = "ca/.", name = "Colored Antiphon Response" }, {
    t("<c><sp>A/</sp>.</c>")
  }),

  -- Responsory Response
  s({ trig = "r/.", name = "Responsory Response" }, {
    t("<sp>R/</sp>.")
  }),

  -- Verse
  s({ trig = "v/.", name = "Verse" }, {
    t("<sp>V/</sp>.")
  }),

  -- Bold markup with placeholder
  s({ trig = "bold", name = "Bold Markup" }, 
    fmt("<b>{}</b>", { i(1, "text") })
  ),

  -- Italic markup with placeholder
  s({ trig = "italic", name = "Italic Markup" },
    fmt("<i>{}</i>", { i(1, "text") })
  ),

  -- Color markup with placeholder
  s({ trig = "color", name = "Color Markup" },
    fmt("<c>{}</c>", { i(1, "text") })
  ),

  -- Small caps markup
  s({ trig = "smallcaps", name = "Small Caps Markup" },
    fmt("<sc>{}</sc>", { i(1, "text") })
  ),

  -- Basic note with choice node
  s({ trig = "note", name = "GABC Note" },
    fmt("{}({})", {
      i(1, "text"),
      c(2, {
        t("f"), t("g"), t("h"), t("i"), t("j"), t("k"), t("l"), t("m")
      })
    })
  ),

  -- Clef with choice node
  s({ trig = "clef", name = "Clef" },
    fmt("({}{})", {
      c(1, { t("c"), t("f"), t("cb") }),
      c(2, { t("1"), t("2"), t("3"), t("4") })
    })
  ),

  -- Complete GABC header template
  s({ trig = "gabcheader", name = "GABC Header Template" }, {
    t("name: "), i(1, "Title"), t(";"),
    t({ "", "annotation: " }), i(2, "Annotation"), t(";"),
    t({ "", "mode: " }), i(3, "1"), t(";"),
    t({ "", "initial-style: " }), i(4, "1"), t(";"),
    t({ "", "%%" }),
  }),

  -- NABC header template
  s({ trig = "nabcheader", name = "NABC Header Template" }, {
    t("name: "), i(1, "Title"), t(";"),
    t({ "", "annotation: " }), i(2, "Annotation"), t(";"),
    t({ "", "mode: " }), i(3, "1"), t(";"),
    t({ "", "nabc-lines: " }), i(4, "1"), t(";"),
    t({ "", "initial-style: " }), i(5, "1"), t(";"),
    t({ "", "%%" }),
  }),

  -- Neume patterns
  s({ trig = "pes", name = "Pes" },
    fmt("{}({}{})", { i(1, "text"), i(2, "f"), i(3, "g") })
  ),

  s({ trig = "clivis", name = "Clivis" },
    fmt("{}({}{})", { i(1, "text"), i(2, "g"), i(3, "f") })
  ),

  s({ trig = "torculus", name = "Torculus" },
    fmt("{}({}{}{})", { i(1, "text"), i(2, "f"), i(3, "g"), i(4, "f") })
  ),

  s({ trig = "porrectus", name = "Porrectus" },
    fmt("{}({}{}{})", { i(1, "text"), i(2, "g"), i(3, "f"), i(4, "g") })
  ),

  -- Special characters with escape
  s({ trig = "\\~", name = "Special Tilde" }, {
    t("<sp>~</sp>")
  }),

  s({ trig = "\\-", name = "Special Dash" }, {
    t("<sp>-</sp>")
  }),

  s({ trig = "\\\\", name = "Special Backslash" }, {
    t("<sp>\\</sp>")
  }),

  -- Bar types
  s({ trig = "virgula", name = "Virgula" }, {
    t("(`)")
  }),

  s({ trig = "divisio", name = "Divisio" },
    fmt("({})", {
      c(1, {
        t(","),  -- minima
        t(";"),  -- minor
        t(":"),  -- maior
        t("::"), -- finalis
      })
    })
  ),

  s({ trig = "finalis", name = "Divisio Finalis" }, {
    t("(::)")
  }),
}
```

### Method 3: Hybrid Approach (Best of Both Worlds)

Load SnipMate snippets for compatibility while adding custom LuaSnip extensions:

```lua
-- In init.lua
local luasnip = require('luasnip')

-- 1. Load existing SnipMate snippets
require('luasnip.loaders.from_snipmate').lazy_load()

-- 2. Load custom LuaSnip snippets (if created)
require('luasnip.loaders.from_lua').lazy_load({
  paths = '~/.config/nvim/luasnippets'
})

-- 3. Configure LuaSnip
luasnip.config.setup({
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,
})
```

## Keybindings

### Basic Setup

```lua
-- Expand or jump forward
vim.keymap.set({'i', 's'}, '<C-k>', function()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  end
end, { silent = true })

-- Jump backward
vim.keymap.set({'i', 's'}, '<C-j>', function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  end
end, { silent = true })

-- Cycle through choice nodes
vim.keymap.set({'i', 's'}, '<C-l>', function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end, { silent = true })
```

### Advanced Setup with Tab

```lua
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Tab to expand snippet or jump forward
vim.keymap.set({'i', 's'}, '<Tab>', function()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  elseif has_words_before() then
    -- Fallback to default tab behavior or trigger completion
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 'n')
  end
end, { silent = true })

-- Shift-Tab to jump backward
vim.keymap.set({'i', 's'}, '<S-Tab>', function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  end
end, { silent = true })
```

## Integration with nvim-cmp

For autocompletion support:

```lua
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = {
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
})

-- Setup for GABC filetype specifically
cmp.setup.filetype('gabc', {
  sources = {
    { name = 'luasnip', priority = 1000 },  -- Prioritize snippets for GABC
    { name = 'buffer', priority = 500 },
  },
})
```

## Available Snippets

### Response Markings

| Trigger | Description | Output |
|---------|-------------|--------|
| `a/.` | Antiphon Response | `<sp>A/</sp>.` |
| `ca/.` | Colored Antiphon | `<c><sp>A/</sp>.</c>` |
| `r/.` | Responsory Response | `<sp>R/</sp>.` |
| `cr/.` | Colored Responsory | `<c><sp>R/</sp>.</c>` |
| `v/.` | Verse | `<sp>V/</sp>.` |
| `cv/.` | Colored Verse | `<c><sp>V/</sp>.</c>` |

### Markup Tags

| Trigger | Description | Output |
|---------|-------------|--------|
| `bold` | Bold text | `<b>text</b>` |
| `italic` | Italic text | `<i>text</i>` |
| `color` | Colored text | `<c>text</c>` |
| `smallcaps` | Small caps | `<sc>text</sc>` |
| `underline` | Underlined text | `<ul>text</ul>` |
| `teletype` | Teletype font | `<tt>text</tt>` |

### Special Characters

| Trigger | Description | Output |
|---------|-------------|--------|
| `c+` | Colored plus | `<c>+</c>` |
| `c*` | Colored asterisk | `<c>*</c>` |
| `\~` | Special tilde | `<sp>~</sp>` |
| `\-` | Special dash | `<sp>-</sp>` |
| `\\` | Special backslash | `<sp>\</sp>` |
| `\&` | Special ampersand | `<sp>&</sp>` |
| `\#` | Special hash | `<sp>#</sp>` |
| `\_` | Special underscore | `<sp>_</sp>` |

### Verbatim Brackets

| Trigger | Description | Output |
|---------|-------------|--------|
| `\(` | Verbatim left paren | `<sp>(</sp>` |
| `\)` | Verbatim right paren | `<sp>)</sp>` |
| `\[` | Verbatim left bracket | `<sp>[</sp>` |
| `\]` | Verbatim right bracket | `<sp>]</sp>` |
| `c\(` | Colored left paren | `<c><sp>(</sp></c>` |

### GABC Headers

| Trigger | Description |
|---------|-------------|
| `gabcheader` | Complete GABC header template |
| `nabcheader` | GABC header with NABC extension |

### Common Neumes

| Trigger | Description | Example Output |
|---------|-------------|----------------|
| `punctum` | Single note | `text(f)` |
| `pes` | Two ascending notes | `text(fg)` |
| `clivis` | Two descending notes | `text(gf)` |
| `torculus` | Three-note neume | `text(fgf)` |
| `porrectus` | Three-note neume | `text(gfg)` |
| `scandicus` | Three ascending | `text(fgh)` |
| `salicus` | Special neume | `text(fgoh)` |

### Clefs and Bars

| Trigger | Description | Output |
|---------|-------------|--------|
| `clef` | Clef notation | `(c4)` with choices |
| `virgula` | Virgula bar | `` (`) `` |
| `divisio` | Division marks | `(,)` with choices |
| `finalis` | Final bar | `(::)` |

## Usage Examples

### Example 1: Creating a Simple Chant

```gabc
name: Kyrie eleison;
annotation: XVII;
mode: 1;
%%
```

1. Type `a/.` + Tab → `<sp>A/</sp>.`
2. Type `Ký` then `punctum` + Tab → `Ký(f)` (edit f to desired note)
3. Type `ri` then `pes` + Tab → `ri(fg)` (edit notes as needed)
4. Type `finalis` + Tab → `(::)`

### Example 2: Using Choice Nodes

```gabc
%%
```

1. Type `clef` + Tab
2. Press Ctrl+L to cycle through `c`, `f`, `cb`
3. Tab to next field
4. Press Ctrl+L to cycle through `1`, `2`, `3`, `4`
5. Result: `(c4)` or any combination

### Example 3: Markup with Placeholders

```gabc
%%
Ký
```

1. Type `bold` + Tab → `<b>text</b>` with cursor on "text"
2. Type replacement: `<b>Ký</b>`
3. Tab moves to next placeholder if any

### Example 4: Fast Response Creation

For creating a responsory:

```gabc
%%
```

1. `r/.` + Tab → `<sp>R/</sp>.` 
2. Space, type text and notes
3. `v/.` + Tab → `<sp>V/</sp>.`
4. Continue with verse text

## Advanced Snippets

### Dynamic Snippets with Functions

Create context-aware snippets:

```lua
-- In ~/.config/nvim/luasnippets/gabc.lua
local ls = require('luasnip')
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node

-- Auto-increment note based on previous
s({ trig = "autonote", name = "Auto Note" }, {
  f(function()
    local line = vim.api.nvim_get_current_line()
    local prev_note = line:match("%(([a-m])%)$")
    if prev_note then
      return "(" .. string.char(string.byte(prev_note) + 1) .. ")"
    else
      return "(f)"
    end
  end, {}),
}),
```

### Conditional Snippets

Show snippets only in specific contexts:

```lua
-- Only expand after syllable text (before parentheses)
local in_notation = function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local before = line:sub(1, col)
  return before:match("%)%s*$") == nil
end

s({
  trig = "note",
  condition = in_notation,
}, {
  -- snippet definition
}),
```

## Troubleshooting

### Snippets Not Loading

1. **Check snippet loader**:
```lua
:lua print(vim.inspect(require('luasnip').available()))
```

2. **Verify filetype**:
```vim
:set filetype?
" Should show: filetype=gabc
```

3. **Force reload**:
```lua
:lua require('luasnip.loaders.from_snipmate').load()
```

### Snippets Not Triggering

1. **Check keybindings**:
```vim
:verbose imap <Tab>
:verbose imap <C-k>
```

2. **Test expansion manually**:
```lua
:lua require('luasnip').expand()
```

### Conflicts with Other Plugins

If you have multiple snippet engines:

```lua
-- Disable other snippet engines for GABC
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'gabc',
  callback = function()
    vim.b.coc_suggest_disable = 1  -- Disable CoC snippets
    vim.g.UltiSnipsExpandTrigger = "<Nop>"  -- Disable UltiSnips
  end,
})
```

## Performance Tips

1. **Lazy load snippets**:
```lua
require('luasnip.loaders.from_snipmate').lazy_load()
-- Better than: require('luasnip.loaders.from_snipmate').load()
```

2. **Limit snippet sources**:
```lua
-- Only load GABC snippets for GABC files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'gabc',
  callback = function()
    require('luasnip.loaders.from_snipmate').lazy_load({
      include = { 'gabc' }
    })
  end,
})
```

3. **Use autosnippets sparingly**: Regular snippets are sufficient for most use cases

## Complete Configuration Example

Here's a complete, ready-to-use configuration:

```lua
-- In your init.lua or lua/plugins/luasnip.lua

return {
  'L3MON4D3/LuaSnip',
  version = 'v2.*',
  build = 'make install_jsregexp',
  dependencies = {
    'saadparwaiz1/cmp_luasnip',
  },
  config = function()
    local ls = require('luasnip')
    
    -- Load snippets
    require('luasnip.loaders.from_snipmate').lazy_load()
    
    -- Configure
    ls.config.setup({
      history = true,
      updateevents = "TextChanged,TextChangedI",
      enable_autosnippets = false,
    })
    
    -- Keymaps
    vim.keymap.set({'i', 's'}, '<C-k>', function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      end
    end, { silent = true })
    
    vim.keymap.set({'i', 's'}, '<C-j>', function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end, { silent = true })
    
    vim.keymap.set({'i', 's'}, '<C-l>', function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end)
  end,
}
```

## Resources

- [LuaSnip Documentation](https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md)
- [LuaSnip Wiki](https://github.com/L3MON4D3/LuaSnip/wiki)
- [Snippet Examples](https://github.com/L3MON4D3/LuaSnip/tree/master/Examples)
- [GABC Documentation](http://gregorio-project.github.io/gabc/)

## Contributing Snippets

If you create useful GABC snippets for LuaSnip:

1. Add them to `~/.config/nvim/luasnippets/gabc.lua`
2. Test thoroughly with various GABC files
3. Consider contributing back to the project via Pull Request

## Next Steps

- Explore the [gregorio.nvim commands](../README.md#commands) for additional productivity
- Check out [Tree-sitter integration](INTEGRATION.md) for advanced features
- Join the discussion on GitHub to share your snippets and workflows
