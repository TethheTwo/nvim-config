return {
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    opts = function()
      dofile(vim.g.base46_cache .. "whichkey")
      return {}
    end,
  },
  -- noice disabled — user prefers standard nvim cmdline at bottom
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      { "<leader>ip", function() require("snacks.image").hover() end, desc = "preview image at cursor" },
    },
    opts = {
      indent = { enabled = true, char = "│", scope = { enabled = true, char = "│" } },
      notifier = { enabled = true, timeout = 3000 },
      scroll = { enabled = true },
      statuscolumn = { enabled = true, folds = { open = true } },
      words = { enabled = true },
      image = { enabled = true, doc = { inline = false, float = false } },
    },
    config = function(_, opts)
      require("snacks").setup(opts)
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end
        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "next hunk" })
        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "prev hunk" })
        map({ "n", "x" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "stage hunk" })
        map({ "n", "x" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "reset hunk" })
        map("n", "<leader>hS", gs.stage_buffer, { desc = "stage buffer" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "undo stage hunk" })
        map("n", "<leader>hR", gs.reset_buffer, { desc = "reset buffer" })
        map("n", "<leader>hp", gs.preview_hunk, { desc = "preview hunk" })
        map("n", "<leader>hb", function()
          gs.blame_line { full = true }
        end, { desc = "blame line" })
        map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "toggle line blame" })
        map("n", "<leader>hd", gs.diffthis, { desc = "diff this" })
        map("n", "<leader>hD", function()
          gs.diffthis "~"
        end, { desc = "diff this ~" })
      end,
    },
  },
  {
    "stevearc/conform.nvim",
    cmd = { "Format", "ConformInfo" },
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "prettier",
        "stylua",
        "black",
        "isort",
        "goimports",
        "latexindent",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        markdown = { "prettier" },
        go = { "gofmt", "goimports" },
        rust = { "rustfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        tex = { "latexindent" },
      },
      formatters = {
        prettier = {
          inherit = false,
          command = "prettier",
          args = function(_, ctx)
            return {
              "--stdin-filepath", ctx.filename,
              "--tab-width", "4",
              "--use-tabs=false",
              "--print-width", "9999",
            }
          end,
        },
        ["clang-format"] = {
          prepend_args = { "-style={IndentWidth: 4, TabWidth: 4, UseTab: Never}" },
        },
      },
    },
    config = function(_, opts)
      local conform = require("conform")
      conform.setup(opts)
      vim.api.nvim_create_user_command("Format", function(args)
        if args.count == -1 then
          conform.format({ async = true, lsp_fallback = true })
          return
        end
        local bufnr = vim.api.nvim_get_current_buf()
        local original = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local sel = vim.list_slice(original, args.line1, args.line2)
        local names = conform.list_formatters_for_buffer(bufnr)
        local formatters = conform.resolve_formatters(names, bufnr, false, false)
        if vim.tbl_isempty(formatters) then
          conform.format({ async = true, lsp_fallback = true })
          return
        end
        local base_indent = (sel[1] or ""):match("^[ \t]*") or ""
        local err, output = require("conform.runner").format_lines_sync(
          bufnr, formatters, 5000,
          { start = { 1, 0 }, ["end"] = { #sel, 0 } },
          sel,
          { exclusive = false, dry_run = false, undojoin = false }
        )
        if err or not output or #output == 0 then
          return
        end
        if output[#output] == "" then
          table.remove(output)
        end
        for i, line in ipairs(output) do
          output[i] = base_indent .. line
        end
        vim.api.nvim_buf_set_lines(bufnr, args.line1 - 1, args.line2, false, output)
      end, { range = true })
    end,
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      linters_by_ft = {
        python = { "ruff" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
      },
    },
    config = function(_, opts)
      local lint = require "lint"
      lint.linters_by_ft = opts.linters_by_ft
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
    end,
  },
}
