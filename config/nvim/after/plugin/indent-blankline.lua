-- Adds indent guides
local indent_blankline = require('ibl')
local hooks = require('ibl.hooks')

hooks.register(hooks.type.HIGHLIGHT_SETUP, function ()
  vim.api.nvim_set_hl(0, "IblIndent", { fg = "#303040" })
  vim.api.nvim_set_hl(0, "IblWhitespace", { fg = "#303040" })
  vim.api.nvim_set_hl(0, "IblScope", { fg = "#303040" })
end)

indent_blankline.setup({
  indent = {
    char = "▏",
  },
})
