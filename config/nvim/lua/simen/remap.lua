vim.g.mapleader = " "

vim.keymap.set("n", "<C-n>", vim.cmd.Ex)

vim.keymap.set("n", "<leader>gp", ":diffput<CR>")
vim.keymap.set("n", "<leader>gg", ":diffget<CR>")
vim.keymap.set("n", "<leader>gt", ":diffget //2<CR>")
vim.keymap.set("n", "<leader>gn", ":diffget //3<CR>")
