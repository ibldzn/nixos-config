local function prequire(name, setup)
  local mod_ok, mod = pcall(require, name)
  if not mod_ok then
    vim.notify("Failed to load config module " .. name, vim.log.levels.ERROR)
    return
  end

  if setup ~= false then
    local setup_ok = pcall(mod.setup)
    if not setup_ok then
      vim.notify("Failed to setup config module " .. name, vim.log.levels.ERROR)
    end
  end

  return mod
end

local impatient_ok, impatient = pcall(require, "impatient")
if impatient_ok then
  impatient.enable_profile()
end

prequire("options")
prequire("pack")
prequire("plugins")
prequire("mappings")
prequire("colors")
prequire("autocmds")
prequire("diagnostics")
prequire("util.select")
