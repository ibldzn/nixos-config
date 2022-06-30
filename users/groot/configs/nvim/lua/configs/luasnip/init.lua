local M = {}

local wk = require("which-key")
local luasnip = require("luasnip")

function M.setup()
  luasnip.config.setup({
    updateevents = "InsertLeave,TextChanged,TextChangedI",
  })

  wk.register({
    ["<Tab>"] = {
      function()
        if luasnip.jumpable(1) then
          luasnip.jump(1)
        end
      end,
      "Jump to next snippet input",
    },
    ["<S-Tab>"] = {
      function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        end
      end,
      "Jump to previous snippet input",
    },
  }, {
    mode = "v",
  })

  local function add(lang)
    luasnip.add_snippets(lang, require("configs.luasnip.lang." .. lang))
  end

  require("luasnip.loaders.from_vscode").lazy_load()

  add("go")
  add("lua")
  add("cmake")
  add("markdown")
end

return M
