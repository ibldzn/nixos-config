local M = {}

local cheat_sheet = require("cheat-sheet")
local wk = require("which-key")
local shared = require("shared")

function M.setup()
  cheat_sheet.setup({
    auto_fill = {
      current_word = false,
    },

    main_win = {
      border = shared.window.border,
    },

    input_win = {
      border = shared.window.border,
    },
  })

  wk.register({
    ["<leader>t"] = {
      name = "Toggle",
      ["c"] = { "<cmd>CheatSH<CR>", "Cheat sheet" },
    },
  })
end

return M
