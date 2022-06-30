local M = {}

local plugins = {
  ["nvim-lua/plenary.nvim"] = {},
  ["lewis6991/impatient.nvim"] = {},
  ["kyazdani42/nvim-web-devicons"] = {},

  ["folke/which-key.nvim"] = {
    config = function()
      require("configs.which-key").setup()
    end,
  },

  ["wbthomason/packer.nvim"] = {
    config = function()
      require("configs.packer").setup()
    end,
  },

  ["nvim-lualine/lualine.nvim"] = {
    after = "nvim-web-devicons",
    config = function()
      require("configs.lualine").setup()
    end,
  },

  ["lukas-reineke/indent-blankline.nvim"] = {
    event = "BufRead",
    config = function()
      require("configs.indent-blankline").setup()
    end,
  },

  ["norcalli/nvim-colorizer.lua"] = {
    event = "BufRead",
    config = function()
      require("configs.colorizer").setup()
    end,
  },

  ["nvim-treesitter/nvim-treesitter"] = {
    event = { "BufRead", "BufNewFile" },
    run = ":TSUpdate",
    requires = {
      {
        "saecki/nvim-treesitter-context",
        branch = "exact_queries",
      },
    },
    config = function()
      require("configs.treesitter").setup()
    end,
  },

  ["lewis6991/gitsigns.nvim"] = {
    event = "BufRead",
    config = function()
      require("configs.gitsigns").setup()
    end,
  },

  ["williamboman/nvim-lsp-installer"] = {
    event = "BufRead",
    setup = function()
      require("configs.lsp-installer").setup()
    end,
  },

  ["neovim/nvim-lspconfig"] = {
    after = "nvim-lsp-installer",
    module = "lspconfig",
    config = function()
      require("configs.lsp").setup()
    end,
  },

  ["ray-x/lsp_signature.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require("configs.lsp-signature").setup()
    end,
  },

  ["mfussenegger/nvim-dap"] = {
    after = "nvim-lspconfig",
    requires = { "rcarriga/nvim-dap-ui" },
    config = function()
      require("configs.dap").setup()
    end,
  },

  ["folke/trouble.nvim"] = {
    after = "nvim-lspconfig",
    requires = { "folke/todo-comments.nvim" },
    config = function()
      require("configs.trouble").setup()
    end,
  },

  ["jose-elias-alvarez/null-ls.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require("configs.null-ls").setup()
    end,
  },

  ["simrat39/rust-tools.nvim"] = {
    ft = "rust",
    config = function()
      require("configs.rust-tools").setup()
    end,
  },

  ["tpope/vim-surround"] = { event = "BufRead" },
  ["andymass/vim-matchup"] = { event = "BufRead" },
  ["farmergreg/vim-lastplace"] = { event = "BufRead" },

  ["jbyuki/venn.nvim"] = {
    event = "BufRead",
    config = function()
      require("configs.venn").setup()
    end,
  },

  ["tpope/vim-fugitive"] = {
    event = "BufRead",
    config = function()
      require("configs.fugitive").setup()
    end,
  },

  ["rafamadriz/friendly-snippets"] = {
    module = "cmp_nvim_lsp",
    event = "InsertEnter",
  },

  ["hrsh7th/nvim-cmp"] = {
    after = "friendly-snippets",
    config = function()
      require("configs.cmp").setup()
    end,
  },

  ["L3MON4D3/LuaSnip"] = {
    after = "nvim-cmp",
    config = function()
      require("configs.luasnip").setup()
    end,
  },

  ["saadparwaiz1/cmp_luasnip"] = { after = "LuaSnip" },
  ["hrsh7th/cmp-nvim-lua"] = { after = "cmp_luasnip" },
  ["hrsh7th/cmp-nvim-lsp"] = { after = "cmp-nvim-lua" },
  ["hrsh7th/cmp-buffer"] = { after = "cmp-nvim-lsp" },
  ["hrsh7th/cmp-path"] = { after = "cmp-buffer" },

  ["saecki/crates.nvim"] = {
    event = "BufRead Cargo.toml",
    config = function()
      require("configs.crates").setup()
    end,
  },

  ["windwp/nvim-autopairs"] = {
    after = "nvim-cmp",
    config = function()
      require("configs.autopairs").setup()
    end,
  },

  ["numToStr/Comment.nvim"] = {
    event = "BufRead",
    config = function()
      require("configs.comment").setup()
    end,
  },

  ["kyazdani42/nvim-tree.lua"] = {
    event = "UIEnter",
    config = function()
      require("configs.nvim-tree").setup()
    end,
  },

  ["nvim-telescope/telescope.nvim"] = {
    event = "UIEnter",
    config = function()
      require("configs.telescope").setup()
    end,
  },

  ["nvim-telescope/telescope-dap.nvim"] = {
    after = { "nvim-dap", "telescope.nvim" },
    config = function()
      require("configs.telescope.dap").setup()
    end,
  },

  ["mrjones2014/smart-splits.nvim"] = {
    event = "WinEnter",
    config = function()
      require("configs.smart-splits").setup()
    end,
  },

  ["rcarriga/nvim-notify"] = {
    config = function()
      require("configs.notify").setup()
    end,
  },

  ["ibldzn/cheat-sheet"] = {
    event = "UIEnter",
    config = function()
      require("configs.cheat-sheet").setup()
    end,
  },

  ["goolord/alpha-nvim"] = {
    event = "VimEnter",
    config = function()
      require("configs.alpha").setup()
    end,
  },

  ["iamcco/markdown-preview.nvim"] = {
    ft = "markdown",
    run = "cd app && npm install",
  },

  ["mattn/emmet-vim"] = {
    ft = {
      "html",
      "css",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("Emmet", {}),
        pattern = {
          "html",
          "css",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
        },
        command = "EmmetInstall",
      })
    end,
  },
}

function M.setup()
  require("pack").run(plugins)
end

return M
