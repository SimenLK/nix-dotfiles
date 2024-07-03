local obsidian = require("obsidian")

obsidian.setup({
  workspaces = {
    {
      name = "snd-brain",
      path = "~/snd-brain",
    }
  },

  new_notes_location = "zettelkasten",

  templates = {
    folder = "templates",
    date_format = "YYYY-MM-DD",
    time_format = "HH:mm",
  },
})
