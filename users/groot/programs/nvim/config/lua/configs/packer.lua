local M = {}

local packer = require("packer")
local util = require("util")
local shared = require("shared")
local wk = require("which-key")

local function snapshot(name)
  if not name then
    name = vim.fn.input("snapshot name: ", shared.packer.snapshot_version)
  end

  if name == "" then
    vim.notify("invalid name for snapshot!", vim.log.levels.ERROR)
    return
  end

  packer.snapshot(name)

  local function format_snapshot()
    local path = util.join_paths(shared.packer.snapshot_path, name)
    local tmp_path = util.join_paths(shared.packer.snapshot_path, name .. "_tmp")
    os.execute("jq --sort-keys . " .. path .. " > " .. tmp_path)
    os.rename(tmp_path, path)
  end
  vim.defer_fn(format_snapshot, 1000)
end

function M.setup()
  wk.register({
    ["<leader>p"] = {
      name = "Packer",
      ["c"] = { ":PackerCompile<cr>", "Compile" },
      ["i"] = { ":PackerInstall<cr>", "Install" },
      ["s"] = { ":PackerSync<cr>", "Sync" },
      ["S"] = { ":PackerStatus<cr>", "Status" },
      ["u"] = { ":PackerUpdate<cr>", "Update" },
      ["b"] = { snapshot, "Backup (snapshot)" },
    },
  })
end

return M
