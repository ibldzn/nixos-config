local alpha = require("alpha")

-- To split our quote, artist and source.
-- And automatically center it for screen loader of the header.
local function split(s)
  local t = {}
  local max_line_length = vim.api.nvim_get_option("columns")
  local longest = 0 -- Value of longest string is 0 by default
  for far in s:gmatch("[^\r\n]+") do
    -- Break the line if it's actually bigger than terminal columns
    local line
    far:gsub("(%s*)(%S+)", function(spc, word)
      if not line or #line + #spc + #word > max_line_length then
        table.insert(t, line)
        line = word
      else
        line = line .. spc .. word
        longest = max_line_length
      end
    end)
    -- Get the string that is the longest
    if #line > longest then
      longest = #line
    end
    table.insert(t, line)
  end
  -- Center all strings by the longest
  for i = 1, #t do
    local space = longest - #t[i]
    local left = math.floor(space / 2)
    local right = space - left
    t[i] = string.rep(" ", left) .. t[i] .. string.rep(" ", right)
  end
  return t
end

-- Function to retrieve console output.
local function capture(cmd)
  local handle = assert(io.popen(cmd, "r"))
  local output = assert(handle:read("*a"))
  handle:close()
  return output
end

-- Create button for initial keybind.
--- @param sc string
--- @param txt string
--- @param keybind string optional
--- @param keybind_opts table optional
local function button(sc, txt, keybind, keybind_opts)
  local sc_ = sc:gsub("%s", ""):gsub("LDR", "<leader>")

  local opts = {
    position = "center",
    shortcut = sc,
    cursor = 5,
    width = 50,
    align_shortcut = "right",
    hl_shortcut = "Conditional",
  }
  if keybind then
    keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
    opts.keymap = { "n", sc_, keybind, keybind_opts }
  end

  local function on_press()
    local key = vim.api.nvim_replace_termcodes(sc_ .. "<Ignore>", true, false, true)
    vim.api.nvim_feedkeys(key, "normal", false)
  end

  return {
    type = "button",
    val = txt,
    on_press = on_press,
    opts = opts,
  }
end

-- All custom headers
Headers = {

  -- {
  --   [[                                                                     ]],
  --   [[       ███████████           █████      ██                     ]],
  --   [[      ███████████             █████                             ]],
  --   [[      ████████████████ ███████████ ███   ███████     ]],
  --   [[     ████████████████ ████████████ █████ ██████████████   ]],
  --   [[    █████████████████████████████ █████ █████ ████ █████   ]],
  --   [[  ██████████████████████████████████ █████ █████ ████ █████  ]],
  --   [[ ██████  ███ █████████████████ ████ █████ █████ ████ ██████ ]],
  --   [[ ██████   ██  ███████████████   ██ █████████████████ ]],
  --   [[ ██████   ██  ███████████████   ██ █████████████████ ]],
  -- },

  -- {
  --   '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ',
  --   '⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡖⠁⠀⠀⠀⠀⠀⠀⠈⢲⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀ ',
  --   '⠀⠀⠀⠀⠀⠀⠀⠀⣼⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣧⠀⠀⠀⠀⠀⠀⠀⠀ ',
  --   '⠀⠀⠀⠀⠀⠀⠀⣸⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣇⠀⠀⠀⠀⠀⠀⠀ ',
  --   '⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀⢀⣀⣤⣤⣤⣤⣀⡀⠀⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀ ',
  --   '⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣔⢿⡿⠟⠛⠛⠻⢿⡿⣢⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀ ',
  --   '⠀⠀⠀⠀⣀⣤⣶⣾⣿⣿⣿⣷⣤⣀⡀⢀⣀⣤⣾⣿⣿⣿⣷⣶⣤⡀⠀⠀⠀⠀ ',
  --   '⠀⠀⢠⣾⣿⡿⠿⠿⠿⣿⣿⣿⣿⡿⠏⠻⢿⣿⣿⣿⣿⠿⠿⠿⢿⣿⣷⡀⠀⠀ ',
  --   '⠀⢠⡿⠋⠁⠀⠀⢸⣿⡇⠉⠻⣿⠇⠀⠀⠸⣿⡿⠋⢰⣿⡇⠀⠀⠈⠙⢿⡄⠀ ',
  --   '⠀⡿⠁⠀⠀⠀⠀⠘⣿⣷⡀⠀⠰⣿⣶⣶⣿⡎⠀⢀⣾⣿⠇⠀⠀⠀⠀⠈⢿⠀ ',
  --   '⠀⡇⠀⠀⠀⠀⠀⠀⠹⣿⣷⣄⠀⣿⣿⣿⣿⠀⣠⣾⣿⠏⠀⠀⠀⠀⠀⠀⢸⠀ ',
  --   '⠀⠁⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⢇⣿⣿⣿⣿⡸⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠈⠀ ',
  --   '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ',
  --   '⠀⠀⠀⠐⢤⣀⣀⢀⣀⣠⣴⣿⣿⠿⠋⠙⠿⣿⣿⣦⣄⣀⠀⠀⣀⡠⠂⠀⠀⠀ ',
  --   '⠀⠀⠀⠀⠀⠈⠉⠛⠛⠛⠛⠉⠀⠀⠀⠀⠀⠈⠉⠛⠛⠛⠛⠋⠁⠀⠀⠀⠀⠀ ',
  -- },

  -- {
  --   [[=================     ===============     ===============   ========  ========]],
  --   [[\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //]],
  --   [[||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||]],
  --   [[|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||]],
  --   [[||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||]],
  --   [[|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||]],
  --   [[||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||]],
  --   [[|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||]],
  --   [[||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||]],
  --   [[||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||]],
  --   [[||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||]],
  --   [[||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||]],
  --   [[||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||]],
  --   [[||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||]],
  --   [[||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||]],
  --   [[||.=='    _-'                                                     `' |  /==.||]],
  --   [[=='    _-'                        N E O V I M                         \/   `==]],
  --   [[\   _-'                                                                `-_   /]],
  --   [[ `''                                                                      ``' ]],
  -- },

  {
    [[  ／|_       ]],
    [[ (o o /      ]],
    [[  |.   ~.    ]],
    [[  じしf_,)ノ ]],
  },

  -- {
  --   "          ▀████▀▄▄              ▄█ ",
  --   "            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ",
  --   "    ▄        █          ▀▀▀▀▄  ▄▀  ",
  --   "   ▄▀ ▀▄      ▀▄              ▀▄▀  ",
  --   "  ▄▀    █     █▀   ▄█▀▄      ▄█    ",
  --   "  ▀▄     ▀▄  █     ▀██▀     ██▄█   ",
  --   "   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ",
  --   "    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ",
  --   "   █   █  █      ▄▄           ▄▀   ",
  -- },

  -- {
  --   "                                                     ",
  --   "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
  --   "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
  --   "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
  --   "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
  --   "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
  --   "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
  --   "                                                     ",
  -- },

  -- {
  --   [[                               __                ]],
  --   [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
  --   [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
  --   [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
  --   [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
  --   [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
  -- },
}

--
-- Sections for Alpha.
--

local header = {
  type = "text",
  -- val = Headers[math.random(#Headers)],
  val = Headers[1],
  opts = {
    position = "center",
    hl = "Type",
    -- wrap = "overflow";
  },
}

local function footer_string()
  ---@diagnostic disable-next-line: undefined-global
  local plugins = #vim.tbl_keys(packer_plugins)
  local v = vim.version()
  local datetime = os.date(" %d-%m-%Y  %H:%M:%S")
  return string.format(" %d  v%d.%d.%d %s", plugins, v.major, v.minor, v.patch, datetime)
end

local footer = {
  type = "text",
  -- Change 'rdn' to any program that gives you a random quote.
  -- https://github.com/BeyondMagic/scripts/blob/master/quotes/rdn
  -- Which returns one to three lines, being each divided by a line break.
  -- Or just an array: { "I see you:", "Above you." }
  -- val = split(capture("rdn")),
  val = split(footer_string()),
  hl = "NvimTreeRootFolder",
  opts = {
    position = "center",
    hl = "Conditional",
  },
}

local buttons = {
  type = "group",
  val = {
    button("LDR n b", "  New buffer", ":tabnew<CR>"),
    button("LDR f f", "  Find file", ":Telescope find_files<CR>"),
    button("LDR f o", "  Recently opened files", ":Telescope oldfiles<CR>"),
    button("LDR f w", "  Find word", ":Telescope live_grep<CR>"),
    button("LDR e s", "  Settings", ":e $MYVIMRC | :cd %:p:h<CR>"),
    button("LDR s p", "  Sync plugins", ":PackerSync<CR>"),
    button("q", "  Quit", ":qa!<CR>"),
  },
  opts = {
    spacing = 1,
  },
}

--
-- Centering handler of ALPHA
--

local ol = { -- occupied lines
  icon = #header.val, -- CONST: number of lines that your header will occupy
  message = 1 + #footer.val, -- CONST: because of padding at the bottom
  length_buttons = #buttons.val * 2 - 1, -- CONST: it calculate the number that buttons will occupy
  neovim_lines = 3, -- CONST: 2 of command line, 1 of the top bar
  padding_between = 2, -- STATIC: can be set to anything, padding between keybinds and header
}

local left_terminal_value = vim.api.nvim_get_option("lines")
  - (ol.length_buttons + ol.message + ol.padding_between + ol.icon + ol.neovim_lines)
local top_padding = math.floor(left_terminal_value / 2)
local bottom_padding = left_terminal_value - top_padding

--
-- Set alpha sections
--

local opts = {
  layout = {
    { type = "padding", val = top_padding },
    header,
    { type = "padding", val = ol.padding_between },
    buttons,
    footer,
    { type = "padding", val = bottom_padding },
  },
  opts = {
    margin = 5,
  },
}

local M = {}

function M.setup()
  alpha.setup(opts)
end

return M
