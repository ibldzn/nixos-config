local M = {}

local colorizer = require("colorizer")

function M.setup()
  colorizer.setup({})
  vim.cmd("ColorizerReloadAllBuffers")
end

return M
