local function find_local_build()
    local result = "make"

    local build = vim.fs.find('build.sh', {
        type = "file"
    })

    print("Found:", vim.inspect(build))

    if not vim.tbl_isempty(build) then
        result = "./build.sh"
    end

    return result
end

vim.opt_local.makeprg = find_local_build()
vim.opt_local.cino = "(0,W4"
vim.opt_local.textwidth = 80
