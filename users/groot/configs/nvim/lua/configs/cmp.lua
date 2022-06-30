local M = {}

local cmp = require("cmp")
local luasnip = require("luasnip")
local shared = require("shared")

local kind_icons = {
  ["Class"] = "🅒 ",
  ["Interface"] = "🅘 ",
  ["TypeParameter"] = "🅣 ",
  ["Struct"] = "🅢",
  ["Enum"] = "🅔 ",
  ["Unit"] = "🅤 ",
  ["EnumMember"] = "🅔 ",
  ["Constant"] = "🅒 ",
  ["Field"] = "🅕 ",
  ["Property"] = " ",
  ["Variable"] = "🅥 ",
  ["Reference"] = "🅡 ",
  ["Function"] = "🅕 ",
  ["Method"] = "🅜 ",
  ["Constructor"] = "🅒 ",
  ["Module"] = "🅜 ",
  ["File"] = "🅕 ",
  ["Folder"] = "🅕 ",
  ["Keyword"] = "🅚 ",
  ["Operator"] = "🅞 ",
  ["Snippet"] = "🅢 ",
  ["Value"] = "🅥 ",
  ["Color"] = "🅒 ",
  ["Event"] = "🅔 ",
  ["Text"] = "🅣 ",
}

function M.setup()
  cmp.setup({
    window = {
      completion = {
        col_offset = -3,
      },
      documentation = {
        border = shared.window.border,
        winhighlight = "Pmenu:Pmenu,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        zindex = 1001,
      },
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(_, vim_item)
        vim_item.menu = vim_item.kind
        vim_item.kind = kind_icons[vim_item.kind] or "  "
        return vim_item
      end,
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = {
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.jumpable(1) then
          luasnip.jump(1)
        else
          fallback()
        end
      end),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-u>"] = cmp.mapping.scroll_docs(-4),
      ["<C-d>"] = cmp.mapping.scroll_docs(4),
      ["<C-space>"] = cmp.mapping.complete(),
      ["<C-q>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      }),
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "crates" },
      { name = "luasnip" },
      { name = "path" },
      { name = "buffer", keyword_length = 4 },
    },
    experimental = {
      native_menu = false,
      ghost_text = true,
    },
  })
end

return M
