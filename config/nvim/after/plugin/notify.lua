local notify = require('notify')

notify.setup({
  background_colour = "NotifyBackground",
})

vim.notify = notify
