local M = {}

local ss = require("smart-splits")
local wk = require("which-key")

function M.setup()
  ss.setup({})

  wk.register({
    name = "Move",
    ["<C-h>"] = { ss.move_cursor_left, "Left split" },
    ["<C-j>"] = { ss.move_cursor_down, "Below split" },
    ["<C-k>"] = { ss.move_cursor_up, "Above split" },
    ["<C-l>"] = { ss.move_cursor_right, "Right split" },
  })

  wk.register({
    name = "Resize split",
    ["<A-h>"] = { ss.resize_left, "Left" },
    ["<A-j>"] = { ss.resize_down, "Down" },
    ["<A-k>"] = { ss.resize_up, "Up" },
    ["<A-l>"] = { ss.resize_right, "Right" },
  })
end

return M
