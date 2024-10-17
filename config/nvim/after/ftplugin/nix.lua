-- nix
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2

local context = require('treesitter-context')

context.setup{
  enable = false
}
