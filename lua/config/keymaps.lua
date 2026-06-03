local map = vim.keymap.set
local opts = { silent = true }

map("n", ";", ":", { desc = "cmd enter" })

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "better j" })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "better k" })

-- move lines
map("n", "<A-j>", ":m .+1<CR>==", opts)
map("n", "<A-k>", ":m .-2<CR>==", opts)
map("x", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("x", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- buffers
map("n", "<leader>x", ":bd<CR>", { desc = "close buffer" })

-- tabpages
map("n", "]t", ":tabnext<CR>", opts)
map("n", "[t", ":tabprev<CR>", opts)

-- window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- resize
map("n", "<C-Up>", ":resize -2<CR>", opts)
map("n", "<C-Down>", ":resize +2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- clear search
map("n", "<Esc>", ":nohlsearch<CR>", opts)

-- save
map({ "n", "x" }, "<C-s>", ":w<CR>", { desc = "save file" })
map("n", "<leader>w", ":w<CR>", { desc = "save" })
map("n", "<leader>q", ":q<CR>", { desc = "quit" })

-- toggle line wrap
map("n", "<leader>z", function()
  vim.wo.wrap = not vim.wo.wrap
  print("wrap " .. (vim.wo.wrap and "on" or "off"))
end, { desc = "toggle line wrap" })
