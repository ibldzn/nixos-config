local M = {}

function M.setup()
  local util = require("util")
  local install_path = vim.fn.stdpath("data")
    .. util.path_separator()
    .. util.join_paths("site", "pack", "packer", "start", "packer.nvim")

  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.notify("Cloning packer..")

    vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    })

    vim.cmd("packadd packer.nvim")
    require("plugins").setup()
    vim.cmd("PackerSync")
  end
end

function M.run(plugins)
  -- load before other plugins
  local notify_ok, notify = pcall(require, "notify")
  if notify_ok then
    vim.notify = notify
  end

  local packer_ok, packer = pcall(require, "packer")
  if not packer_ok then
    vim.notify("packer isn't installed", vim.log.levels.ERROR)
    return
  end

  local packer_options = {
    auto_clean = true,
    compile_on_sync = true,
    git = { clone_timeout = 6000 },
    display = {
      working_sym = " ﲊ",
      error_sym = "✗ ",
      done_sym = " ",
      removed_sym = " ",
      moved_sym = "",
      open_fn = function()
        return require("packer.util").float({ border = require("shared").window.border })
      end,
    },
  }

  packer.init(packer_options)

  local packer_compiled_ok = pcall(require, "packer_compiled")
  if not packer_compiled_ok then
    vim.notify("compiled packer config wasn't found", vim.log.levels.ERROR)
  end

  local shared = require("shared")

  packer.startup({
    function(use)
      local plugins_table = {}
      for name, _ in pairs(plugins) do
        plugins[name][1] = name
        plugins_table[#plugins_table + 1] = plugins[name]
      end

      for _, plugin in pairs(plugins_table) do
        use(plugin)
      end
    end,

    config = {
      compile_path = shared.packer.compile_path,
      snapshot_path = shared.packer.snapshot_path,
    },
  })
end

return M
