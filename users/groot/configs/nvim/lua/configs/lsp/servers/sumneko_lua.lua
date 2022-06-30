local M = {}

function M.setup(lspconfig, on_init, on_attach, capabilities)
  lspconfig.sumneko_lua.setup({
    on_init = on_init,
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  })
end

return M
