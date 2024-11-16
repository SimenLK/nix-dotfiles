local configs = require('nvim-treesitter.configs')
local context = require('treesitter-context')

configs.setup {
	highlight = {
		enable = true,
	},
}

context.setup{
  enable = true,
  max_lines = 4,
}
