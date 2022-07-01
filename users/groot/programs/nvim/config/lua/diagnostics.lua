local M = {}

local wk = require("which-key")
local shared = require("shared")

function M.setup()
  local signs = { Error = "", Warn = "", Hint = "", Info = "" }
  for n, s in pairs(signs) do
    local hl = "DiagnosticSign" .. n
    vim.fn.sign_define(hl, { text = s, texthl = hl, linehl = "", numhl = "" })
  end
  vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = true,
    severity_sort = true,
    float = {
      border = shared.window.border,
    },
  })

  wk.register({
    ["g"] = {
      name = "Go",
      ["["] = { vim.diagnostic.goto_prev, "Previous diagnostic" },
      ["]"] = { vim.diagnostic.goto_next, "Next diagnostic" },
    },
  })
end

return M
