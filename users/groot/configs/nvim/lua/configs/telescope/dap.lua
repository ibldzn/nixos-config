local M = {}

local telescope = require("telescope")
local wk = require("which-key")

function M.setup()
  telescope.load_extension("dap")

  wk.register({
    ["<leader>d"] = {
      name = "Debug",
      ["s"] = { "<cmd>Telescope dap frames<CR>", "Stack frames" },
      ["l"] = { "<cmd>Telescope dap list_breakpoints<CR>", "List breakpoints" },
    },
  })
end

return M
