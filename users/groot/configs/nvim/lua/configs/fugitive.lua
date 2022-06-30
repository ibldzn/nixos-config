local M = {}

local wk = require("which-key")

function M.setup()
  wk.register({
    ["<leader>g"] = {
      name = "Git",
      ["g"] = { "<cmd>0G<CR>", "Menu" },
      ["cd"] = { "<cmd>Gcd<CR>", "CD to git root" },
    },
  })
end

return M
