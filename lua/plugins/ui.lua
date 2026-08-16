return {
  {
    "nvchad/base46",
    lazy = false,
    config = function()
      require("base46").load_all_highlights()
    end,
    build = function()
      require("base46").load_all_highlights()
    end,
  },
  {
    "nvchad/ui",
    lazy = false,
    config = function()
      require "nvchad"
    end,
    build = function()
      local path = vim.fn.stdpath("data") .. "/lazy/ui/lua/nvchad/au.lua"
      local lines = vim.fn.readfile(path)
      if not vim.tbl_contains(lines, "    if vim.api.nvim_buf_is_valid(current_buffer) then") then
        local out = {}
        for _, l in ipairs(lines) do
          if l:match("vim%.api%.nvim_buf_delete%(current_buffer") then
            vim.list_extend(out, {
              "    if vim.api.nvim_buf_is_valid(current_buffer) then",
              "      " .. l,
              "    end",
            })
          else
            out[#out + 1] = l
          end
        end
        vim.fn.writefile(out, path)
      end
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      dofile(vim.g.base46_cache .. "devicons")
      return { override = require "nvchad.icons.devicons" }
    end,
  },
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  "nvzone/volt",
  "nvzone/menu",
  { "nvzone/minty", cmd = { "Huefy", "Shades" } },
}
