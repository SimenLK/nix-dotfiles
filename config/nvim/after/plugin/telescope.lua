local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup()

vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>p", builtin.find_files, {})

vim.keymap.set("n", "<leader>ff", builtin.live_grep, {})
vim.keymap.set("n", "<leader>ma", function() builtin.man_pages { sections = { "ALL" } } end, {})
vim.keymap.set("n", "<leader>b", builtin.buffers, {})
