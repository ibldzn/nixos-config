local M = {}

local gitsigns = require("gitsigns")
local wk = require("which-key")
local shared = require("shared")
local util = require("util")

local function current_line_blame_formatter(name, blame_info, opts)
  if blame_info.author == name then
    blame_info.author = "You"
  end

  local text
  if blame_info.author == "Not Committed Yet" then
    text = blame_info.author
  else
    local date_time

    if opts.relative_time then
      date_time = require("gitsigns.util").get_relative_time(tonumber(blame_info["author_time"]))
    else
      date_time = os.date("%Y-%m-%d", tonumber(blame_info["author_time"]))
    end

    text = string.format("// %s, %s - %s", blame_info.author, date_time, blame_info.summary)
  end

  return { { text, "Comment" } }
end

function M.setup()
  gitsigns.setup({
    signs = {
      add = { hl = "GitSignsAdd", text = "▌", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
      change = {
        hl = "GitSignsChange",
        text = "▌",
        numhl = "GitSignsChangeNr",
        linehl = "GitSignsChangeLn",
      },
      delete = {
        hl = "GitSignsDelete",
        text = "▌",
        numhl = "GitSignsDeleteNr",
        linehl = "GitSignsDeleteLn",
      },
      topdelete = {
        hl = "GitSignsDelete",
        text = "▌",
        numhl = "GitSignsDeleteNr",
        linehl = "GitSignsDeleteLn",
      },
      changedelete = {
        hl = "GitSignsChgDel",
        text = "▌",
        numhl = "GitSignsChgDelNr",
        linehl = "GitSignsChgDelLn",
      },
    },
    numhl = false,
    linehl = false,
    word_diff = false,
    keymaps = {},
    current_line_blame = true,
    current_line_blame_formatter = current_line_blame_formatter,
    current_line_blame_formatter_opts = {
      relative_time = true,
    },
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 0,
    },
    sign_priority = 100,
    update_debounce = 100,
    diff_opts = {
      internal = true,
    },
    base = "HEAD",
    preview_config = {
      border = shared.window.border,
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
  })
  -- stylua: ignore end
  wk.register({
    ["g"] = {
      name = "Go",
      ["}"] = { util.wrap(vim.schedule, gitsigns.next_hunk), "Next hunk" },
      ["{"] = { util.wrap(vim.schedule, gitsigns.prev_hunk), "Previous hunk" },
    },

    ["<leader>g"] = {
      name = "Git",
      ["s"] = { gitsigns.stage_hunk, "Stage hunk" },
      ["r"] = { gitsigns.reset_hunk, "Reset hunk" },
      ["S"] = { gitsigns.stage_buffer, "Stage buffer" },
      ["u"] = { gitsigns.undo_stage_hunk, "Undo stage hunk" },
      ["R"] = { gitsigns.reset_buffer, "Reset buffer" },
      ["p"] = { gitsigns.preview_hunk, "Preview hunk" },
      ["d"] = { gitsigns.diffthis, "Diff this hunk" },
      ["b"] = { util.wrap(gitsigns.blame_line, { full = true }), "Blame line" },
      ["B"] = { gitsigns.toggle_current_line_blame, "Toggle inline blame" },
    },
  })
end

return M
