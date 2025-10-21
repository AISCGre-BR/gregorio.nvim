# LuaSnip Quick Start for gregorio.nvim

Get up and running with LuaSnip snippets in 5 minutes!

## Prerequisites

```lua
-- Add to your plugin manager (lazy.nvim example)
{
  'L3MON4D3/LuaSnip',
  version = 'v2.*',
  build = 'make install_jsregexp',
}
```

## Step 1: Basic Setup (Choose One)

### Option A: Automatic Loading (Simplest)

```lua
-- In your init.lua after LuaSnip is loaded
require('luasnip.loaders.from_snipmate').lazy_load()
```

This automatically loads all gregorio.nvim snippets! ✅

### Option B: Native LuaSnip Format (More Features)

```lua
-- In your init.lua
require('gabc.luasnip').setup()
```

This uses gregorio.nvim's native LuaSnip integration with choice nodes and dynamic features.

## Step 2: Add Keybindings

```lua
-- In your init.lua or keymaps.lua
local ls = require('luasnip')

-- Expand snippet or jump forward
vim.keymap.set({'i', 's'}, '<C-k>', function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

-- Jump backward
vim.keymap.set({'i', 's'}, '<C-j>', function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

-- Cycle through choices (for advanced snippets)
vim.keymap.set({'i', 's'}, '<C-l>', function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)
```

## Step 3: Test It!

Open a `.gabc` file and try:

1. Type `a/.` → Press `Ctrl+K` → Get `<sp>A/</sp>.` ✨
2. Type `bold` → Press `Ctrl+K` → Get `<b>text</b>` with cursor on "text"
3. Type `clef` → Press `Ctrl+K` → Press `Ctrl+L` to cycle through clef types

## Most Used Snippets

| Trigger | Result | Use Case |
|---------|--------|----------|
| `a/.` | `<sp>A/</sp>.` | Antiphon marker |
| `r/.` | `<sp>R/</sp>.` | Responsory marker |
| `v/.` | `<sp>V/</sp>.` | Verse marker |
| `bold` | `<b>text</b>` | Bold formatting |
| `italic` | `<i>text</i>` | Italic formatting |
| `gabcheader` | Complete header | Start new file |
| `pes` | `text(fg)` | Two ascending notes |
| `clivis` | `text(gf)` | Two descending notes |
| `clef` | `(c4)` with choices | Insert clef |
| `finalis` | `(::)` | Final bar |

## Complete Example Configuration

Here's a ready-to-use configuration with nvim-cmp integration:

```lua
-- In your plugins configuration
return {
  -- LuaSnip
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = 'make install_jsregexp',
    config = function()
      local ls = require('luasnip')
      
      -- Option A: Load SnipMate format snippets (automatic)
      require('luasnip.loaders.from_snipmate').lazy_load()
      
      -- Option B: Load native LuaSnip snippets (more features)
      -- require('gabc.luasnip').setup()
      
      -- Configure
      ls.config.setup({
        history = true,
        updateevents = "TextChanged,TextChangedI",
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
  },

  -- nvim-cmp integration
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        sources = {
          { name = 'luasnip', priority = 1000 },
          { name = 'nvim_lsp' },
          { name = 'buffer' },
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
        }),
      })
      
      -- High priority for GABC snippets
      cmp.setup.filetype('gabc', {
        sources = {
          { name = 'luasnip', priority = 1000 },
          { name = 'buffer' },
        },
      })
    end,
  },

  -- gregorio.nvim
  {
    'AISCGre-BR/gregorio.nvim',
    ft = 'gabc',
  },
}
```

## Troubleshooting

### Snippets not working?

1. Check filetype: `:set filetype?` should show `gabc`
2. Verify LuaSnip loaded: `:lua print(vim.inspect(require('luasnip').available()))`
3. Test manually: `:lua require('luasnip').expand()`

### Want to see all snippets?

```vim
:lua vim.print(require('luasnip').available())
```

Or use a snippet picker plugin like [telescope-luasnip.nvim](https://github.com/benfowler/telescope-luasnip.nvim).

## Next Steps

- 📖 [Full LuaSnip Integration Guide](LUASNIP_INTEGRATION.md) - Advanced features and customization
- 📚 [gregorio.nvim Commands](../README.md#commands) - Learn about markup commands and transposition
- 🎵 [GABC Tutorial](http://gregorio-project.github.io/gabc/) - Master GABC notation

## Example Workflow

Creating a simple antiphon:

```gabc
name: Salve Regina;
annotation: VI;
%%
```

1. Type `a/.` + Ctrl+K → `<sp>A/</sp>.` 
2. Type `Sal(f)ve(g) Re(h)gí(i)na(h)` 
3. Type `bold` + Ctrl+K → `<b>text</b>` → Replace with `<b>Sal</b>(f)ve...`
4. Type `finalis` + Ctrl+K → `(::)`

Result:
```gabc
name: Salve Regina;
annotation: VI;
%%
<sp>A/</sp>. <b>Sal</b>(f)ve(g) Re(h)gí(i)na(h) (::)
```

Happy chanting! 🎵
