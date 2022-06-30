local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node

return {
  s("addex", {
    t({ "add_executable(" }),
    i(1, { "${PROJECT_NAME}" }),
    t({ "", "  " }),
    i(2, { "" }),
    t({ "", ")" }),
  }),
  s("addlib", {
    t({ "add_library(" }),
    i(1, { "${PROJECT_NAME}" }),
    t({ " " }),
    i(2, { "STATIC" }),
    t({ "", "  " }),
    i(3, { "" }),
    t({ "", ")" }),
  }),
}
