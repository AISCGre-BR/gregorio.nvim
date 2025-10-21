-- Example LuaSnip configuration for gregorio.nvim
-- Place this in ~/.config/nvim/luasnippets/gabc.lua
-- or copy snippets to your main configuration

-- Method 1: Use gregorio.nvim built-in snippets
-- This is the recommended approach - loads all snippets from the plugin
return require('gabc.luasnip').get_snippets()

-- Method 2: Extend with custom snippets
-- Uncomment below to add your own snippets to the built-in ones
--[[
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt

-- Get built-in snippets
local gabc_snippets = require('gabc.luasnip').get_snippets()

-- Add your custom snippets
local custom_snippets = {
  -- Example: Custom kyrie snippet
  s({ trig = "kyrie", name = "Kyrie eleison", dscr = "Complete Kyrie phrase" },
    fmt("Ký({}ri({}e({}) e({}lé({}i({}son.({})", {
      i(1, "f"),
      i(2, "gfg"),
      i(3, "h."),
      i(4, "ixjvIH'GhvF'E"),
      i(5, "ghg'"),
      i(6, "g"),
      i(7, "f.")
    })
  ),

  -- Example: Custom alleluia
  s({ trig = "alleluia", name = "Alleluia", dscr = "Alleluia melisma" },
    fmt("Al({}le({}lú({}ia.({})", {
      i(1, "f"),
      i(2, "gh"),
      i(3, "ixhg"),
      i(4, "gf.")
    })
  ),

  -- Add more custom snippets here
}

-- Merge built-in and custom snippets
for _, snip in ipairs(custom_snippets) do
  table.insert(gabc_snippets, snip)
end

return gabc_snippets
]]

-- Method 3: Completely custom snippets
-- Uncomment below to use only your own snippets (not recommended)
--[[
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require('luasnip.extras.fmt').fmt

return {
  -- Your custom snippets here
  s({ trig = "mysnippet", name = "My Custom Snippet" }, {
    t("Custom text")
  }),
}
]]
