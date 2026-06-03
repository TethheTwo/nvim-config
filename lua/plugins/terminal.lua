return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = 20,
      open_mapping = [[<C-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        width = function()
          return math.floor(vim.o.columns * 0.8)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.8)
        end,
        winblend = 3,
      },
    },
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<CR>", desc = "toggle terminal" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "terminal horizontal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", desc = "terminal vertical" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "terminal float" },
      { "<leader>tl", "<cmd>TermExec cmd='lazygit'<CR>", desc = "lazygit" },
    },
  },
}
