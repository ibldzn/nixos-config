local M = {}

local lualine = require("lualine")
-- local lsp_status = require("lsp-status")

-- stylua: ignore start
local modemap = {
    ["n"]    = "N ",
    ["no"]   = "O ",
    ["nov"]  = "O ",
    ["noV"]  = "O ",
    ["no"] = "O ",
    ["niI"]  = "N ",
    ["niR"]  = "N ",
    ["niV"]  = "N ",
    ["v"]    = "V ",
    ["V"]    = "VL",
    [""]   = "VB",
    ["s"]    = "S ",
    ["S"]    = "SL",
    [""]   = "SB",
    ["i"]    = "I ",
    ["ic"]   = "I ",
    ["ix"]   = "I ",
    ["R"]    = "R ",
    ["Rc"]   = "R ",
    ["Rv"]   = "VR",
    ["Rx"]   = "R ",
    ["c"]    = "C ",
    ["cv"]   = "EX",
    ["ce"]   = "EX",
    ["r"]    = "R ",
    ["rm"]   = "MORE",
    ["r?"]   = "CONFIRM",
    ["!"]    = "SHELL",
    ["t"]    = "TERMINAL",
}
-- stylua: ignore end

local function mode()
  local mode_code = vim.api.nvim_get_mode().mode
  if modemap[mode_code] == nil then
    return mode_code
  end
  return modemap[mode_code]
end

local function fileformat()
  return vim.bo.fileformat
end

local function position()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local linecount = vim.api.nvim_buf_line_count(0)
  local linedigits = math.floor(math.log10(linecount)) + 1

  local template = "%" .. linedigits .. "d:%-2d"
  return string.format(template, cursor[1], cursor[2])
end

local function lsp_indicator()
  local clients = vim.lsp.buf_get_clients()
  local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
  local prog = vim.lsp.util.get_progress_messages()[1]

  local client = nil
  for _, cl in pairs(clients) do
    local filetypes = cl.config.filetypes
    if cl.name ~= "null-ls" then
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        client = cl
        break
      end
    end
  end

  if client == nil then
    return ""
  end

  if not prog then
    return ""
  end

  local spinners = { "", "" }
  local ms = vim.loop.hrtime() / 1000000
  local frame = math.floor(ms / 120) % #spinners

  return spinners[frame + 1]
end

function M.setup()
  local colors = require("colors.mineauto")
  local theme = colors.lualine
  local filename_symbols = {
    modified = " ",
    readonly = " ",
    unnamed = "unnamed",
  }

  lualine.setup({
    options = {
      icons_enabled = true,
      theme = theme,
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
      globalstatus = true,
    },
    sections = {
      lualine_a = {
        { mode, separator = { left = " " } },
      },
      lualine_b = {},
      lualine_c = {
        {
          "filename",
          path = 1,
          symbols = filename_symbols,
        },
      },
      lualine_x = { lsp_indicator, "filetype", fileformat, "encoding" },
      lualine_y = {
        { "branch" },
        {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          sections = { "error", "warn", "info", "hint" },
          symbols = { error = " ", warn = " ", info = " ", hint = " " },
          diagnostics_color = {
            error = "DiagnosticSignError",
            warn = "DiagnosticSignWarn",
            info = "DiagnosticSignInfo",
            hint = "DiagnosticSignHint",
          },
        },
      },
      lualine_z = {
        { position, separator = { right = " " } },
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        {
          "filename",
          path = 1,
          symbols = filename_symbols,
          separator = { left = " " },
        },
      },
      lualine_x = {
        { "location", separator = { right = " " } },
      },
      lualine_y = {},
      lualine_z = {},
    },
    extensions = {},
  })
end

return M
