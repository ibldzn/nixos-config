local M = {}

local ts_config = require("nvim-treesitter.configs")
local ts_context = require("treesitter-context")
local CATEGORY = ts_context.CATEGORY or {}

function M.setup()
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

  ts_config.setup({
    ensure_installed = {
      "bash",
      "c",
      "cmake",
      "comment",
      "cpp",
      "css",
      "dockerfile",
      "go",
      "graphql",
      "html",
      "java",
      "json",
      "kotlin",
      "latex",
      "lua",
      "markdown",
      "nix",
      "python",
      "query",
      "regex",
      "rust",
      "toml",
      "vim",
      "yaml",
      "zig",
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        scope_incremental = "<CR>",
        node_incremental = "<Tab>",
        node_decremental = "<S-Tab>",
      },
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  })

  ts_context.setup({
    mode = "topline",
    truncate_side = "outer",
    max_lines = 2,
    categories = {
      default = {
        CATEGORY.CLASS,
        CATEGORY.INTERFACE,
        CATEGORY.STRUCT,
        CATEGORY.ENUM,
        CATEGORY.FUNCTION,
        CATEGORY.METHOD,
        CATEGORY.SECTION,
      },
    },
  })
end

return M
