local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node

return {
  s("forall", t("∀")),
  s("exists", t("∃")),
  s("in", t("∈")),
  s("notin", t("∉")),
  s("subset", t("⊆")),
  s("subsetnoteq", t("⊂")),
  s("intersect", t("∩")),
  s("union", t("∪")),
  s("setmin", t("∖")),

  s("land", t("∧")),
  s("lor", t("∨")),
  s("xor", t("⊻")),
}
