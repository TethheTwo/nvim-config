return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      require("nvim-dap-virtual-text").setup()
      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "toggle breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "continue" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "step into" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "step over" })
      vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "step out" })
      vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "toggle repl" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "run last" })
      vim.keymap.set("n", "<leader>dx", function()
        dap.terminate()
        dapui.close()
      end, { desc = "terminate" })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      ensure_installed = {},
      handlers = {},
    },
  },
}
