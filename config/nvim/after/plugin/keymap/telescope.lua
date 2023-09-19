local Remap = require("simen.keymap")
local nnoremap = Remap.nnoremap

nnoremap("<C-p>", ":Telescope git_files<CR>")
