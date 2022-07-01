local M = {}

function M.setup()
  -- vim.g.loaded_python3_provider = 0
  vim.g.python3_host_prog = "/bin/python3"
  vim.g.neovide_refresh_rate = 144

  vim.g.format_on_save = true
  vim.g.user_emmet_leader_key = ","
  vim.g.user_emmet_install_global = 0

  -- use filetype.lua instead of filetype.vim
  vim.g.did_load_filetypes = 0
  vim.g.do_filetype_lua = 1
  vim.g.mapleader = " "

  -----------------------------------------------------------
  -- Encodings
  -----------------------------------------------------------
  vim.opt.encoding = "utf-8"
  vim.opt.fileencoding = "utf-8"
  vim.opt.fileencodings = "utf-8"

  -----------------------------------------------------------
  -- General
  -----------------------------------------------------------
  -- Font for gui client
  vim.opt.guifont = "JetBrainsMono Nerd Font:h10"
  -- Enable mouse
  vim.opt.mouse = "a"
  -- Disable swap file
  vim.opt.swapfile = false
  -- Use system clipboard
  vim.opt.clipboard = "unnamedplus"
  -- Fix backspace
  vim.opt.backspace = "indent,eol,start"
  -- Line numbers columns
  vim.opt.signcolumn = "yes:2"
  -- Disable vim compatability
  vim.opt.compatible = false
  -- Autocomplete options
  vim.opt.completeopt = "menuone,noinsert,noselect"
  -- Confirm before exiting
  vim.opt.confirm = true
  -- Show titlebar
  vim.opt.title = true
  vim.opt.showbreak = "⮡   "
  vim.opt.listchars = { space = "·", eol = "⮠" }
  vim.opt.fillchars:append({ horiz = "─", vert = "│", eob = " ", fold = " ", diff = "╱" })

  -----------------------------------------------------------
  -- UI
  -----------------------------------------------------------
  -- Show line numbers
  vim.opt.number = true
  -- Show relative number
  vim.opt.relativenumber = true
  -- Highlight line
  vim.opt.cursorline = true
  -- Highligh just the number instead of the whole line
  vim.opt.cursorlineopt = "number"
  -- Highlight matching parentheses
  vim.opt.showmatch = true
  vim.opt.foldtext =
    [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
  -- Fold level
  vim.opt.foldlevel = 99
  -- Enable 24bit colors
  vim.opt.termguicolors = true
  -- Line wrapping
  vim.opt.wrap = true
  -- Scroll offset
  vim.opt.scrolloff = 5
  -- SANE side scrolling
  vim.opt.sidescroll = 1
  -- Side scrolling offset
  vim.opt.sidescrolloff = 5
  -- Split windows below
  vim.opt.splitbelow = true
  -- Split windows right
  vim.opt.splitright = true
  -- Set global status line
  vim.opt.laststatus = 3
  -- Set background color
  vim.opt.background = "dark"

  -----------------------------------------------------------
  -- Search
  -----------------------------------------------------------
  -- Highlight matching search pattern
  vim.opt.hlsearch = true
  -- Highlight matching search pattern as it is typed
  vim.opt.incsearch = true
  -- Case insensitive search
  vim.opt.ignorecase = true
  -- Override the ignorecase option if there's an uppercase letter
  vim.opt.smartcase = true

  -----------------------------------------------------------
  -- Tabs
  -----------------------------------------------------------
  -- Use spaces instead of tabs
  vim.opt.expandtab = true
  -- Shift 4 spaces when tab
  vim.opt.shiftwidth = 4
  -- 1 tab == 4 spaces
  vim.opt.tabstop = 4
  -- Automatically indent new lines
  vim.opt.smartindent = true

  -----------------------------------------------------------
  -- Memory, CPU
  -----------------------------------------------------------
  -- Enable background buffers
  vim.opt.hidden = true
  -- Remember N lines in history
  vim.opt.history = 100
  -- Faster scrolling
  vim.opt.lazyredraw = true
  -- Max column for syntax highlight
  vim.opt.synmaxcol = 240
  vim.opt.updatetime = 700 -- ms to wait for trigger an event

  -- disable nvim intro
  vim.opt.shortmess:append("sI")

  -- go to previous/next line with h,l,left arrow and right arrow
  -- when cursor reaches end/beginning of line
  vim.opt.whichwrap:append("<>[]hl")

  -- disable some builtin vim plugins

  local default_plugins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "matchit",
    "tar",
    "tarPlugin",
    "rrhelper",
    "spellfile_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
  }

  for _, plugin in pairs(default_plugins) do
    vim.g["loaded_" .. plugin] = 1
  end

  vim.schedule(function()
    vim.opt.shadafile = vim.fn.expand("$HOME") .. "/.local/share/nvim/shada/main.shada"
    vim.cmd([[ silent! rsh ]])
  end)
end

return M
