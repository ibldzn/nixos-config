local M = {}

local lspconfig = require("configs.lsp")
local rust_tools = require("rust-tools")
local shared = require("shared")

function M.setup()
  local rust_tools_opts = {
    tools = {
      autoSetHints = true,
      hover_with_actions = true,
      inlay_hints = {
        show_parameter_hints = false,
        parameter_hints_prefix = "",
        other_hints_prefix = "",
      },

      hover_actions = {
        border = shared.window.border,
      },
    },

    server = {
      on_attach = lspconfig.on_attach,
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy",
          },
        },
      },
    },
  }

  rust_tools.setup(rust_tools_opts)
end

return M
