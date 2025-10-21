-- LuaSnip integration module for gregorio.nvim
-- This module provides native LuaSnip snippets for GABC notation
-- 
-- Usage:
--   require('gabc.luasnip').setup()
-- 
-- Or load from your LuaSnip config:
--   In ~/.config/nvim/luasnippets/gabc.lua:
--   return require('gabc.luasnip').snippets

local M = {}

-- Check if LuaSnip is available
local has_luasnip, ls = pcall(require, 'luasnip')
if not has_luasnip then
  return M
end

-- LuaSnip shorthand
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep

---@type table<string, any>
M.snippets = {
  -- =========================================================================
  -- RESPONSE MARKINGS
  -- =========================================================================
  
  s({ trig = "a/.", name = "Antiphon Response", dscr = "Inserts <sp>A/</sp>." }, {
    t("<sp>A/</sp>.")
  }),

  s({ trig = "ca/.", name = "Colored Antiphon Response", dscr = "Colored antiphon marking" }, {
    t("<c><sp>A/</sp>.</c>")
  }),

  s({ trig = "r/.", name = "Responsory Response", dscr = "Inserts <sp>R/</sp>." }, {
    t("<sp>R/</sp>.")
  }),

  s({ trig = "cr/.", name = "Colored Responsory Response", dscr = "Colored responsory marking" }, {
    t("<c><sp>R/</sp>.</c>")
  }),

  s({ trig = "v/.", name = "Verse", dscr = "Inserts <sp>V/</sp>." }, {
    t("<sp>V/</sp>.")
  }),

  s({ trig = "cv/.", name = "Colored Verse", dscr = "Colored verse marking" }, {
    t("<c><sp>V/</sp>.</c>")
  }),

  -- =========================================================================
  -- MARKUP TAGS WITH PLACEHOLDERS
  -- =========================================================================
  
  s({ trig = "bold", name = "Bold Markup", dscr = "Bold text tag" }, 
    fmt("<b>{}</b>", { i(1, "text") })
  ),

  s({ trig = "italic", name = "Italic Markup", dscr = "Italic text tag" },
    fmt("<i>{}</i>", { i(1, "text") })
  ),

  s({ trig = "color", name = "Color Markup", dscr = "Colored text tag" },
    fmt("<c>{}</c>", { i(1, "text") })
  ),

  s({ trig = "smallcaps", name = "Small Caps Markup", dscr = "Small caps tag" },
    fmt("<sc>{}</sc>", { i(1, "text") })
  ),

  s({ trig = "underline", name = "Underline Markup", dscr = "Underlined text tag" },
    fmt("<ul>{}</ul>", { i(1, "text") })
  ),

  s({ trig = "teletype", name = "Teletype Markup", dscr = "Teletype font tag" },
    fmt("<tt>{}</tt>", { i(1, "text") })
  ),

  -- =========================================================================
  -- SPECIAL CHARACTERS
  -- =========================================================================
  
  s({ trig = "c+", name = "Colored Plus", dscr = "Colored plus sign" }, {
    t("<c>+</c>")
  }),

  s({ trig = "c*", name = "Colored Asterisk", dscr = "Colored asterisk" }, {
    t("<c>*</c>")
  }),

  s({ trig = "\\~", name = "Special Tilde", dscr = "Escaped tilde character" }, {
    t("<sp>~</sp>")
  }),

  s({ trig = "c\\~", name = "Colored Special Tilde", dscr = "Colored escaped tilde" }, {
    t("<c><sp>~</sp></c>")
  }),

  s({ trig = "\\-", name = "Special Dash", dscr = "Escaped dash character" }, {
    t("<sp>-</sp>")
  }),

  s({ trig = "\\\\", name = "Special Backslash", dscr = "Escaped backslash" }, {
    t("<sp>\\</sp>")
  }),

  s({ trig = "\\&", name = "Special Ampersand", dscr = "Escaped ampersand" }, {
    t("<sp>&</sp>")
  }),

  s({ trig = "\\#", name = "Special Hash", dscr = "Escaped hash symbol" }, {
    t("<sp>#</sp>")
  }),

  s({ trig = "\\_", name = "Special Underscore", dscr = "Escaped underscore" }, {
    t("<sp>_</sp>")
  }),

  -- =========================================================================
  -- VERBATIM PARENTHESES AND BRACKETS
  -- =========================================================================
  
  s({ trig = "\\(", name = "Verbatim Left Paren", dscr = "Escaped left parenthesis" }, {
    t("<sp>(</sp>")
  }),

  s({ trig = "\\)", name = "Verbatim Right Paren", dscr = "Escaped right parenthesis" }, {
    t("<sp>)</sp>")
  }),

  s({ trig = "\\[", name = "Verbatim Left Bracket", dscr = "Escaped left bracket" }, {
    t("<sp>[</sp>")
  }),

  s({ trig = "\\]", name = "Verbatim Right Bracket", dscr = "Escaped right bracket" }, {
    t("<sp>]</sp>")
  }),

  s({ trig = "c\\(", name = "Colored Verbatim Left Paren", dscr = "Colored escaped left paren" }, {
    t("<c><sp>(</sp></c>")
  }),

  s({ trig = "c\\)", name = "Colored Verbatim Right Paren", dscr = "Colored escaped right paren" }, {
    t("<c><sp>)</sp></c>")
  }),

  s({ trig = "c\\[", name = "Colored Verbatim Left Bracket", dscr = "Colored escaped left bracket" }, {
    t("<c><sp>[</sp></c>")
  }),

  s({ trig = "c\\]", name = "Colored Verbatim Right Bracket", dscr = "Colored escaped right bracket" }, {
    t("<c><sp>]</sp></c>")
  }),

  -- =========================================================================
  -- GABC HEADERS
  -- =========================================================================
  
  s({ trig = "gabcheader", name = "GABC Header Template", dscr = "Complete GABC header" }, {
    t("name: "), i(1, "Title"), t(";"),
    t({ "", "annotation: " }), i(2, "Annotation"), t(";"),
    t({ "", "mode: " }), i(3, "1"), t(";"),
    t({ "", "initial-style: " }), i(4, "1"), t(";"),
    t({ "", "%%" }),
  }),

  s({ trig = "nabcheader", name = "NABC Header Template", dscr = "GABC header with NABC extension" }, {
    t("name: "), i(1, "Title"), t(";"),
    t({ "", "annotation: " }), i(2, "Annotation"), t(";"),
    t({ "", "mode: " }), i(3, "1"), t(";"),
    t({ "", "nabc-lines: " }), i(4, "1"), t(";"),
    t({ "", "initial-style: " }), i(5, "1"), t(";"),
    t({ "", "%%" }),
  }),

  -- =========================================================================
  -- COMMON NEUMES WITH CHOICE NODES
  -- =========================================================================
  
  s({ trig = "punctum", name = "Punctum", dscr = "Single note" },
    fmt("{}({})", {
      i(1, "text"),
      i(2, "f")
    })
  ),

  s({ trig = "pes", name = "Pes", dscr = "Two ascending notes" },
    fmt("{}({}{})", {
      i(1, "text"),
      i(2, "f"),
      i(3, "g")
    })
  ),

  s({ trig = "clivis", name = "Clivis", dscr = "Two descending notes" },
    fmt("{}({}{})", {
      i(1, "text"),
      i(2, "g"),
      i(3, "f")
    })
  ),

  s({ trig = "scandicus", name = "Scandicus", dscr = "Three ascending notes" },
    fmt("{}({}{}{})", {
      i(1, "text"),
      i(2, "f"),
      i(3, "g"),
      i(4, "h")
    })
  ),

  s({ trig = "salicus", name = "Salicus", dscr = "Special three-note neume" },
    fmt("{}({}{}{})", {
      i(1, "text"),
      i(2, "f"),
      i(3, "g"),
      i(4, "oh")
    })
  ),

  s({ trig = "torculus", name = "Torculus", dscr = "Three-note neume (up-down)" },
    fmt("{}({}{}{})", {
      i(1, "text"),
      i(2, "f"),
      i(3, "g"),
      i(4, "f")
    })
  ),

  s({ trig = "porrectus", name = "Porrectus", dscr = "Three-note neume (down-up)" },
    fmt("{}({}{}{})", {
      i(1, "text"),
      i(2, "g"),
      i(3, "f"),
      i(4, "g")
    })
  ),

  s({ trig = "climacus", name = "Climacus", dscr = "Three descending notes" },
    fmt("{}({}{}{})", {
      i(1, "text"),
      i(2, "h"),
      i(3, "g"),
      i(4, "f")
    })
  ),

  -- =========================================================================
  -- CLEFS AND DIVISIONS WITH CHOICE NODES
  -- =========================================================================
  
  s({ trig = "clef", name = "Clef", dscr = "Clef notation with choices" },
    fmt("({}{})", {
      c(1, {
        t("c"),
        t("f"),
        t("cb")
      }),
      c(2, {
        t("4"),
        t("3"),
        t("2"),
        t("1")
      })
    })
  ),

  s({ trig = "virgula", name = "Virgula", dscr = "Virgula bar" }, {
    t("(`)")
  }),

  s({ trig = "divisio", name = "Divisio", dscr = "Division marks with choices" },
    fmt("({})", {
      c(1, {
        t(","),   -- minima
        t(";"),   -- minor
        t(":"),   -- maior
        t("::"),  -- finalis
      })
    })
  ),

  s({ trig = "finalis", name = "Divisio Finalis", dscr = "Final bar" }, {
    t("(::)")
  }),

  -- =========================================================================
  -- ADVANCED: DYNAMIC SNIPPETS
  -- =========================================================================
  
  -- Repeated syllable pattern
  s({ trig = "repeat", name = "Repeated Syllable", dscr = "Syllable with same notes repeated" },
    fmt("{}({}){}({})", {
      i(1, "Ký"),
      i(2, "f"),
      i(3, "ri"),
      rep(2)  -- Repeats the second placeholder
    })
  ),

  -- Custom note with modifiers choice
  s({ trig = "notemod", name = "Note with Modifier", dscr = "Note with common modifiers" },
    fmt("{}({}{})", {
      i(1, "text"),
      i(2, "g"),
      c(3, {
        t(""),   -- no modifier
        t("w"),  -- quilisma
        t("v"),  -- virga
        t("o"),  -- oriscus
        t("~"),  -- liquescent
        t("<"),  -- liquescent augmentative
        t(">"),  -- liquescent diminutive
      })
    })
  ),
}

--- Setup function to register snippets with LuaSnip
function M.setup()
  if not has_luasnip then
    vim.notify("LuaSnip not found. Skipping snippet registration.", vim.log.levels.WARN)
    return
  end

  -- Add snippets to LuaSnip
  ls.add_snippets("gabc", M.snippets)
  
  vim.notify("gregorio.nvim: LuaSnip snippets registered", vim.log.levels.INFO)
end

--- Get snippets table (for use in luasnippets/gabc.lua)
--- @return table
function M.get_snippets()
  return M.snippets
end

return M
