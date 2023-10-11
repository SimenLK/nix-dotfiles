local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup({
    vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--case-sensitive"
    }
})

vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>p", builtin.find_files, {})

vim.keymap.set("n", "<leader>ff", builtin.live_grep, {})
