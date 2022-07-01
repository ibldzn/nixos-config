local M = {}

local dap = require("dap")
local dap_ui = require("dapui")
local wk = require("which-key")
local util = require("util")

local function run_dap(prompt)
  local ft = vim.bo.filetype
  if ft == "" then
    vim.notify(
      "filetype option is required to determine which dap config to use",
      vim.log.levels.ERROR
    )
    return
  end

  local configs = dap.configurations[ft]
  if configs == nil then
    vim.notify(ft .. " has no dap config", vim.log.levels.ERROR)
    return
  end

  vim.ui.select(configs, {
    prompt = "Select config to run: ",
    format_item = function(cfg)
      return cfg.name
    end,
  }, function(cfg)
    if prompt then
      cfg.args = vim.split(vim.fn.input("args: "), " ")
    end
    dap.run(cfg)
  end)
end

function M.debuggables(prompt)
  local filetype = vim.bo.filetype
  if filetype == "rust" then
    require("configs.dap.rust").debuggables(prompt)
  else
    run_dap(prompt)
  end
end

function M.setup()
  require("configs.dap.adapters").setup()
  require("configs.dap.configurations").setup()

  vim.fn.sign_define(
    "DapBreakpoint",
    { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" }
  )
  vim.fn.sign_define(
    "DapLogPoint",
    { text = "", texthl = "DapLogPoint", linehl = "", numhl = "" }
  )
  vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "", numhl = "" })

  dap.listeners.after.event_initialized["dapui_config"] = util.wrap(dap_ui.open, nil)
  dap.listeners.before.event_terminated["dapui_config"] = util.wrap(dap_ui.close, nil)
  dap.listeners.before.event_exited["dapui_config"] = util.wrap(dap_ui.close, nil)

  dap_ui.setup({
    mappings = {
      expand = { "<CR>", "<Tab>" },
    },
    icons = { expanded = "▾", collapsed = "▸" },
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.4 },
          { id = "breakpoints", size = 0.3 },
          { id = "stacks", size = 0.3 },
        },
        size = 40,
        position = "left",
      },
      -- {
      --   elements = { "repl" },
      --   size = 15,
      --   position = "bottom",
      -- },
    },
    floating = {
      max_height = nil,
      max_width = nil,
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
    windows = { indent = 1 },
  })

  wk.register({
    ["<leader>"] = {
      ["t"] = {
        name = "Toggle",
        ["d"] = { dap_ui.toggle, "Debug UI" },
      },
    },

    ["<leader>d"] = {
      name = "Debug",
      ["C"] = { dap.continue, "Continue" },
      ["o"] = { dap.step_over, "Step over" },
      ["i"] = { dap.step_into, "Step into" },
      ["O"] = { dap.step_out, "Step out" },
      ["d"] = { util.wrap(M.debuggables, false), "Debug", silent = false },
      ["D"] = { util.wrap(M.debuggables, true), "Debug with args", silent = false },
      ["n"] = { dap.run_to_cursor, "Run to cursor" },
      ["R"] = { dap.run_last, "Rerun", silent = false },
      ["r"] = { dap.restart, "Restart", silent = false },
      ["q"] = { dap.close, "Close" },
      ["t"] = { dap.terminate, "Terminate" },
      ["b"] = { dap.toggle_breakpoint, "Breakpoint" },
      ["k"] = { dap.up, "Navigate up the callstack" },
      ["j"] = { dap.down, "Navigate down the callstack" },
      ["B"] = {
        function()
          dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        "Conditional breakpoint",
      },
      ["e"] = {
        function()
          dap_ui.eval(nil, { enter = true })
        end,
        "Evaluate",
      },
      ["E"] = {
        function()
          dap_ui.eval(vim.fn.input("Expression: "), { enter = true })
        end,
        "Evaluate expression",
      },
      ["?"] = {
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.scopes)
        end,
        "Evaluate current scope",
      },
    },
  })
end

return M
