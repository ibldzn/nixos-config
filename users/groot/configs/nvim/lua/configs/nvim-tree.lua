local M = {}

local wk = require("which-key")

function M.setup()
  local nvim_tree = require("nvim-tree")

  nvim_tree.setup({
    filters = {
      dotfiles = false,
      exclude = { "custom" },
    },
    git = {
      enable = true,
      ignore = true,
    },
    actions = {
      open_file = {
        resize_window = true,
      },
    },

    disable_netrw = true,
    hijack_netrw = true,
    ignore_ft_on_setup = { "alpha" },
    open_on_tab = false,
    hijack_cursor = true,
    hijack_unnamed_buffer_when_opening = false,
    update_cwd = true,
    update_focused_file = {
      enable = true,
      update_cwd = false,
    },

    diagnostics = {
      enable = true,
      icons = {
        hint = "",
        info = "",
        warning = "",
        error = "",
      },
    },

    renderer = {
      icons = {
        glyphs = {
          default = "",
          symlink = "",
          git = {
            unstaged = "",
            staged = "",
            unmerged = "",
            renamed = "",
            untracked = "",
            deleted = "",
            ignored = "~",
          },
          folder = {
            arrow_closed = "",
            arrow_open = "",
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
            symlink_open = "",
          },
        },
      },
    },

    view = {
      side = "right",
      width = 30,
    },
  })

  wk.register({
    ["<C-n>"] = { nvim_tree.toggle, "Filetree toggle" },
  })
end

return M
