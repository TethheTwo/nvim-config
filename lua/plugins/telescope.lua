return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        lazy = true,
      },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 10,
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
      },
      pickers = {
        find_files = { theme = "dropdown" },
        live_grep = { theme = "dropdown" },
        buffers = { theme = "dropdown" },
        oldfiles = { theme = "dropdown" },
      },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "find text" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "help" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "recent files" },
      { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "keymaps" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "document symbols" },
    },
  },
}
