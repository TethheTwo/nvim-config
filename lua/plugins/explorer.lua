return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "toggle explorer" },
      { "<leader>E", "<cmd>Neotree focus<CR>", desc = "focus explorer" },
    },
    opts = {
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            "node_modules",
            ".git",
          },
        },
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
      },
      window = {
        position = "left",
        width = 30,
        mappings = {
          ["<space>"] = "none",
          ["<Tab>"] = function(state)
            local node = state.tree:get_node()
            if node.type == "file" then
              for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                local ft = vim.bo[vim.api.nvim_win_get_buf(winid)].filetype
                if ft ~= "neo-tree" then
                  vim.api.nvim_set_current_win(winid)
                  vim.cmd("edit " .. vim.fn.fnameescape(node.path))
                  break
                end
              end
              vim.api.nvim_set_current_win(state.winid)
            elseif node.type == "directory" then
              require("neo-tree.sources.filesystem").toggle_directory(state)
            end
          end,
        },
      },
      default_component_configs = {
        indent = { padding = 1 },
        icon = { folder_closed = "", folder_open = "" },
        git_status = { symbols = {
          added = "✚",
          deleted = "✖",
          modified = "",
          renamed = "",
          untracked = "",
          ignored = "",
          unstaged = "",
          staged = "",
          conflict = "",
        } },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
    end,
  },
}
