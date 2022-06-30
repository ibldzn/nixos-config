local M = {}

function M.setup(lspconfig, on_init, on_attach, capabilities)
  lspconfig.clangd.setup({
    on_init = on_init,
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      client.offset_encoding = "utf-16"
    end,
    capabilities = capabilities,
  })
end

return M
