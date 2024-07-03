local function find_build_script()
  local result = "make"

  if vim.fn.filereadable("build.sh") then
    result = "./build.sh"
  end

  return result
end

vim.opt_local.makeprg = find_build_script()
vim.opt_local.cino = "(0"
vim.opt_local.textwidth = 80
