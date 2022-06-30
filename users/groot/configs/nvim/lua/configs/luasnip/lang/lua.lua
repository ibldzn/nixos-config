local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node

return {
  s("which-key", t('local wk = require("which-key")')),
  s("require", {
    t({ 'require("' }),
    i(0, { "mod" }),
    t({ '")' }),
  }),
  s("module", {
    t({ "local M = {}", "", "function M.setup()", "\t" }),
    i(0, { "" }),
    t({ "", "end", "", "return M" }),
  }),
  s("lspmodule", {
    t({ "local M = {}", "", "function M.setup(lspconfig, on_init, on_attach, capabilities)", "" }),
    t({ "\tlspconfig." }),
    i(1, { "" }),
    t({
      ".setup({",
      "\t\ton_init = on_init,",
      "\t\ton_attach = on_attach,",
      "\t\tcapabilities = capabilities,",
      "\t\t",
    }),
    i(2, { "" }),
    t({ "", "\t})", "end", "", "return M" }),
  }),
}
