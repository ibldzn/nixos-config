local M = {}

local autopairs = require("nvim-autopairs")
local cmp = require("cmp")

function M.setup()
  autopairs.setup({})

  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return M
