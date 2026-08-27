local M = {}

M.base46 = {
  theme = "flexoki",
  theme_toggle = { "flexoki", "flexoki-light" },
  transparency = false,
  favorite_themes = { "default-dark", "everblush", "flexoki", "gruvbox", "gruvchad", "yoru", "flexoki-light", "hiberbee", "midnight_breeze" },
  hl_override = {
    St_file = { bg = "yellow", fg = "black" },
    St_file_sep = { bg = "statusline_bg", fg = "yellow" },
    ["@keyword"] = { fg = "purple" },
    ["@keyword.conditional"] = { fg = "purple" },
    ["@keyword.conditional.ternary"] = { fg = "purple" },
    ["@keyword.repeat"] = { fg = "purple" },
    ["@keyword.return"] = { fg = "purple" },
    ["@keyword.operator"] = { fg = "purple" },
    ["@keyword.directive"] = { fg = "yellow" },
    ["@keyword.directive.define"] = { fg = "yellow" },
    ["@keyword.import"] = { fg = "yellow" },
    ["@type.builtin"] = { fg = "cyan" },
    ["@function"] = { fg = "blue" },
    ["@function.call"] = { fg = "blue" },
    ["@function.builtin"] = { fg = "blue" },
    ["@function.macro"] = { fg = "red" },
    ["@string.escape"] = { fg = "green" },
    ["@character"] = { fg = "green" },
    ["@number"] = { fg = "orange" },
    ["@constant"] = { fg = "red" },
    ["@constant.builtin"] = { fg = "red" },
    ["@constant.macro"] = { fg = "red" },
    ["@variable"] = { fg = "white" },
    ["@variable.builtin"] = { fg = "white" },
    ["@variable.parameter"] = { fg = "pink" },
    ["@property"] = { fg = "blue" },
    ["@punctuation.delimiter"] = { fg = "teal" },
  },
  hl_add = {
    St_file_git_sep = { bg = "orange", fg = "yellow" },
    St_git = { bg = "orange", fg = "black" },
    St_git_sep = { bg = "statusline_bg", fg = "orange" },
    St_live_sep = { bg = "statusline_bg", fg = "green" },
    St_live_icon = { bg = "green", fg = "black" },
    St_live_text = { bg = "lightbg", fg = "green" },
    ["@keyword.type"] = { fg = "cyan" },
    ["@keyword.modifier"] = { fg = "cyan" },
    ["@type"] = { fg = "cyan" },
    ["@type.qualifier"] = { fg = "cyan" },
    ["@type.definition"] = { fg = "cyan" },
    ["@boolean"] = { fg = "orange" },
    ["@label"] = { fg = "pink" },
    ["@punctuation.special"] = { fg = "teal" },
    ["@comment.documentation"] = { fg = "grey" },
  },
}

M.ui = {
  cmp = { style = "default" },
  telescope = { style = "borderless" },
  statusline = {
    enabled = true,
    theme = "default",
    separator_style = "round",
    order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "live", "diagnostics", "lsp", "cwd", "cursor" },
    modules = {
      mode = function()
        local utils = require "nvchad.stl.utils"
        if not utils.is_activewin() then
          return ""
        end
        local modes = utils.modes
        local m = vim.api.nvim_get_mode().mode
        local name = modes[m] and modes[m][2]
        if not name then
          return ""
        end
        local sep_style = M.ui.statusline.separator_style
        local separators = (type(sep_style) == "table" and sep_style) or utils.separators[sep_style]
        return "%#St_" .. name .. "Mode#   " .. modes[m][1]
          .. "%#St_" .. name .. "ModeSep#" .. separators["right"]
          .. "%#St_" .. name .. "Sep2#" .. separators["right"]
      end,
      file = function()
        local utils = require "nvchad.stl.utils"
        local x = utils.file()
        local sep_style = M.ui.statusline.separator_style
        local separators = (type(sep_style) == "table" and sep_style) or utils.separators[sep_style]
        local name = " " .. x[2] .. (sep_style == "default" and " " or "")
        local head = vim.b[utils.stbufnr()] and vim.b[utils.stbufnr()].gitsigns_head
        local sep = (head and head ~= "") and "%#St_file_git_sep#" or "%#St_file_sep#"
        return "%#St_file# " .. x[1] .. name .. sep .. separators["right"]
      end,
      git = function()
        local utils = require "nvchad.stl.utils"
        local head = vim.b[utils.stbufnr()] and vim.b[utils.stbufnr()].gitsigns_head
        if not head or head == "" then
          return ""
        end
        local content = utils.git()
        if content == "" then
          return ""
        end
        local sep_style = M.ui.statusline.separator_style
        local separators = (type(sep_style) == "table" and sep_style) or utils.separators[sep_style]
        return "%#St_git#" .. content .. "%#St_git_sep#" .. separators["right"]
      end,
      live = function()
        local utils = require "nvchad.stl.utils"
        local ok, ls = pcall(require, "config.liveserver")
        if not ok or not ls.is_running() then
          return ""
        end
        local sep_style = M.ui.statusline.separator_style
        local separators = (type(sep_style) == "table" and sep_style) or utils.separators[sep_style]
        local root = ls.root:gsub("/+$", ""):match("([^/]+)$") or ls.root
        return "%#St_live_sep#" .. separators["left"] .. "%#St_live_icon#󰅟 %#St_live_text# " .. ls.port .. " · " .. root .. " "
      end,
    },
  },
  tabufline = {
    enabled = true,
    lazyload = true,
    treeOffsetFt = "neo-tree",
  },
}

M.nvdash = {
  load_on_startup = true,
  header = {
    "                              ",
    "  ▄▄         ▄ ▄▄▄▄▄▄▄       ",
    "  ▀███▄     ▄██ █████▀        ",
    "  ██▄▀███▄   ███             ",
    "  ███  ▀███▄ ███             ",
    "  ███    ▀██ ███             ",
    "  ███      ▀ ███             ",
    "  ▀██ █████▄▀█▀▄██████▄      ",
    "    ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀    ",
    "                              ",
    "         ~ TethheTwo ~        ",
    "                              ",
  },
  buttons = {
    { txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
    { txt = "  Recent Files", keys = "fr", cmd = "Telescope oldfiles" },
    { txt = "󰈭  Find Word", keys = "fw", cmd = "Telescope live_grep" },
    { txt = "  Mason", keys = "cm", cmd = "Mason" },
    { txt = "󰒲  Lazy", keys = "lz", cmd = "Lazy" },
    { txt = "󱥚  Themes", keys = "th", cmd = "ThemeSelect" },
    { txt = "  Quit", keys = "q", cmd = "qa" },
  },
  keymaps = {
    { category = "Navigation" },
    { keys = "j / k", desc = "Move cursor (smart wrap)" },
    { keys = "<C-h/j/k/l>", desc = "Navigate windows" },
    { keys = "<C-Up/Down/Left/Right>", desc = "Resize windows" },
    { keys = "]t / [t", desc = "Next / prev tabpage" },
    { category = "Buffers" },
    { keys = "<Tab> / <S-Tab>", desc = "Next / prev buffer" },
    { keys = "<leader>x", desc = "Close buffer" },
    { category = "Files" },
    { keys = "<leader>e", desc = "File explorer" },
    { keys = "<leader>ff", desc = "Find files" },
    { keys = "<leader>fg", desc = "Live grep (search)" },
    { keys = "<leader>fr", desc = "Recent files" },
    { keys = "<leader>fb", desc = "Buffers list" },
    { keys = "<leader>fh", desc = "Help tags" },
    { keys = "<leader>fk", desc = "Keymaps (telescope)" },
    { keys = "<leader>fs", desc = "LSP symbols" },
    { category = "LSP" },
    { keys = "gd", desc = "Go to definition" },
    { keys = "K", desc = "Hover documentation" },
    { keys = "gi", desc = "Go to implementation" },
    { keys = "gr", desc = "Find references" },
    { keys = "<leader>D", desc = "Type definition" },
    { keys = "<C-k>", desc = "Signature help" },
    { keys = "<leader>rn", desc = "Rename symbol" },
    { keys = "<leader>ca", desc = "Code action" },
    { keys = "<leader>d", desc = "Diagnostic float" },
    { keys = "[d / ]d", desc = "Prev / next diagnostic" },
    { keys = "<leader>q", desc = "Diagnostics to loclist" },
    { category = "Git" },
    { keys = "]c / [c", desc = "Next / prev hunk" },
    { keys = "<leader>hs", desc = "Stage hunk" },
    { keys = "<leader>hr", desc = "Reset hunk" },
    { keys = "<leader>hp", desc = "Preview hunk diff" },
    { keys = "<leader>hb", desc = "Blame line" },
    { keys = "<leader>tb", desc = "Toggle line blame" },
    { keys = "<leader>hd", desc = "Diff this file" },
    { category = "Terminal" },
    { keys = "<C-\\>", desc = "Toggle terminal" },
    { keys = "<leader>tl", desc = "Lazygit" },
    { category = "Edit" },
    { keys = "<A-j> / <A-k>", desc = "Move line up / down" },
    { keys = "<C-s>", desc = "Save file" },
    { keys = "<leader>w", desc = "Save" },
    { keys = "<leader>q", desc = "Quit" },
    { keys = ";", desc = "Enter command mode" },
    { keys = "<Esc>", desc = "Clear search highlight" },
    { category = "Completion (insert)" },
    { keys = "<Tab> / <S-Tab>", desc = "Select next / prev" },
    { keys = "<C-j> / <C-k>", desc = "Select next / prev" },
    { keys = "<CR>", desc = "Accept completion" },
    { keys = "<C-b> / <C-f>", desc = "Scroll doc down / up" },
  },
}

M.term = {
  startinsert = true,
}

return M
