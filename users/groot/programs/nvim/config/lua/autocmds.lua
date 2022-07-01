local M = {}

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local util = require("util")

function M.setup()
  autocmd("FileType", {
    pattern = "alpha",
    callback = function()
      vim.opt.laststatus = 0
    end,
  })

  autocmd("BufUnload", {
    buffer = 0,
    callback = function()
      vim.opt.laststatus = 3
    end,
  })

  autocmd("BufWritePre", {
    group = augroup("Mkdir", {}),
    callback = function()
      local dir = vim.fn.expand("<afile>:p:h")
      if vim.fn.isdirectory(dir) == 0 then
        vim.fn.mkdir(dir, "p")
      end
    end,
  })

  autocmd("TextYankPost", {
    group = augroup("HighlightYank", {}),
    callback = function()
      vim.highlight.on_yank({ timeout = 1000 })
    end,
  })

  autocmd("FileType", {
    group = augroup("SplitHelpWindow", {}),
    pattern = "help",
    callback = function()
      vim.opt_local.bufhidden = "unload"
      vim.cmd("wincmd L")
      vim.api.nvim_win_set_width(0, 90)
    end,
  })

  autocmd("BufWritePre", {
    group = augroup("TrimTrailingWhitespaces", {}),
    pattern = "!*.md",
    command = ":%s/\\s\\+$//e",
  })

  autocmd("BufWritePre", {
    group = augroup("FormatOnSave", {}),
    pattern = "*",
    callback = function(opts)
      util.format_buffer({ bufnr = opts.buf, force = false })
    end,
  })

  autocmd("BufEnter", {
    group = augroup("NoCommentsOnNewLine", {}),
    pattern = "*",
    command = "set fo-=c fo-=r fo-=o",
  })

  autocmd("FileType", {
    group = augroup("IndentTwoSpaces", {}),
    pattern = {
      "xml",
      "html",
      "xhtml",
      "css",
      "scss",
      "javascript",
      "typescript",
      "yaml",
      "typescriptreact",
      "javascriptreact",
      "json",
      "graphql",
      "lua",
      "cmake",
      "tex",
      "nix",
      "NvimTree",
    },
    command = "setlocal shiftwidth=2 tabstop=2",
  })

  autocmd("TermOpen", {
    group = augroup("TermOptions", {}),
    command = "setlocal listchars= nonumber norelativenumber nocursorline signcolumn=no | startinsert",
  })
end

return M
