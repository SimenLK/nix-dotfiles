local obsidian = require("obsidian")

obsidian.setup({
  workspaces = {
    {
      name = "snd-brain",
      path = "~/snd-brain",
      overrides = {
        notes_subdir = "zettelkasten",
      },
    }
  },

  new_notes_location = "notes_subdir",

  templates = {
    folder = "templates",
    date_format = "YYYY-MM-DD",
    time_format = "HH:mm",
  },

  ui = {
    enable = false,
  },
})
