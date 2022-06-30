local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node

return {
  s("main", {
    t({ "package main", "", "" }),
    t({ "func main() {", "\t" }),
    i(0, { "" }),
    t({ "", "}" }),
  }),
}
