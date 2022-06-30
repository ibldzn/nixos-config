local M = {}

local ns = require("null-ls")
local lspconfig = require("configs.lsp")

local fm = ns.builtins.formatting
local dg = ns.builtins.diagnostics

function M.setup()
  ns.setup({
    on_attach = function(client, bufnr)
      lspconfig.on_attach(client, bufnr)
      client.resolved_capabilities.document_formatting = true
      client.resolved_capabilities.document_range_formatting = true
    end,
    debug = false,
    sources = {
      dg.eslint,
      dg.shellcheck,

      fm.black,
      fm.gofmt,
      fm.stylua,
      fm.prettier,
      fm.clang_format,
      fm.rustfmt.with({
        args = {
          "+nightly",
          "--unstable-features",
          "--edition=2021",
          "--emit=stdout",
        },
      }),
    },
  })
end

return M
