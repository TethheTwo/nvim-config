vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46_cache/"
vim.g.mapleader = " "

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require "config.options"
require "config.keymaps"
require "config.autocmds"

require("lazy").setup {
  spec = {
    { import = "plugins" },
  },
  defaults = { lazy = false },
  install = { colorscheme = { "flexoki" } },
  ui = { border = "rounded" },
  performance = {
    cache = { enabled = true },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}

require("config.nvdash").patch()

local function write_favs(favs)
  local config_path = vim.fn.stdpath("config") .. "/lua/chadrc.lua"
  local file = io.open(config_path, "r")
  if not file then return end
  local content = file:read "*a"
  file:close()
  local fav_str = "favorite_themes = { "
  for i, v in ipairs(favs) do
    if i > 1 then fav_str = fav_str .. ", " end
    fav_str = fav_str .. '"' .. v .. '"'
  end
  fav_str = fav_str .. " }"
  content = content:gsub('favorite_themes%s*=%s*{[^}]*}', fav_str)
  file = io.open(config_path, "w")
  file:write(content)
  file:close()
end

vim.api.nvim_create_user_command("ThemeSelect", function()
  local state = require "nvchad.themes.state"
  local ui = require "nvchad.themes.ui"

  local function get_favs()
    return require("nvconfig").base46.favorite_themes or {}
  end

  local function fav_index(favs, name)
    for i, v in ipairs(favs) do
      if v == name then return i end
    end
    return nil
  end

  local orig_compact = ui.compact
  ui.compact = function()
    local result = orig_compact()
    local favs = get_favs()
    local fav_set = {}
    for _, v in ipairs(favs) do fav_set[v] = true end
    for i, line in ipairs(result) do
      local name = state.themes_shown[i]
      if name and fav_set[name] then table.insert(line, 2, { "\u{2B50}", "ExYellow" }) end
    end
    return result
  end

  local orig_bordered = ui.bordered
  ui.bordered = function()
    local result = orig_bordered()
    local favs = get_favs()
    local fav_set = {}
    for _, v in ipairs(favs) do fav_set[v] = true end
    for i = 1, #result, 2 do
      local name = state.themes_shown[(i + 1) / 2]
      if name and fav_set[name] then table.insert(result[i], 2, { "\u{2B50} ", "ExYellow" }) end
    end
    return result
  end

  local orig_flat = ui.flat
  ui.flat = function()
    local result = orig_flat()
    local favs = get_favs()
    local fav_set = {}
    for _, v in ipairs(favs) do fav_set[v] = true end
    for i = 1, #state.themes_shown do
      local name = state.themes_shown[i]
      local idx = i * 3 - 1
      if name and fav_set[name] and result[idx] then table.insert(result[idx], 2, { "\u{2B50} ", "ExYellow" }) end
    end
    return result
  end

  require("nvchad.themes").open {
    mappings = function(buf)
      vim.keymap.set({ "i", "n" }, "<Tab>", function()
        local name = state.themes_shown[state.index]
        if not name then return end
        local favs = get_favs()
        local idx = fav_index(favs, name)
        if idx then
          table.remove(favs, idx)
          vim.notify("\u{2B50} Removed from favorites: " .. name)
        else
          table.insert(favs, name)
          vim.notify("\u{2B50} Added to favorites: " .. name)
        end
        write_favs(favs)
        require("nvconfig").base46.favorite_themes = favs
        require("volt").redraw(state.buf, "all")
      end, { buffer = buf, desc = "toggle favorite" })

      vim.keymap.set({ "i", "n" }, "<cr>", function()
        local name = state.themes_shown[state.index]
        if name then
          local config_path = vim.fn.stdpath("config") .. "/lua/chadrc.lua"
          local file = io.open(config_path, "r")
          if file then
            local content = file:read "*a"
            file:close()
            content = content:gsub('theme%s*=%s*"[^"]*"', 'theme = "' .. name .. '"', 1)
            file = io.open(config_path, "w")
            file:write(content)
            file:close()
          end
          require("nvchad.themes.utils").reload_theme(name)
          state.confirmed = true
          vim.notify("Theme changed to " .. name, vim.log.levels.INFO)
        end
        require("volt").close()
      end, { buffer = buf, desc = "confirm theme" })
    end,
  }
end, {})

vim.keymap.set("n", "<leader>th", "<cmd>ThemeSelect<CR>", { desc = "select theme" })
pcall(vim.keymap.del, "n", "<Tab>")
pcall(vim.keymap.del, "n", "<S-Tab>")
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true, desc = "next buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprev<CR>", { silent = true, desc = "prev buffer" })
