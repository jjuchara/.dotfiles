return {
  {
    "jjuchara/obsidian-tasks.nvim",
    opts = {
      repositories = {
        {
          name = "personal",
          alias = "Personal",
          vault = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/obsidian_jjuchara",
          todo_file = "Tasks/Tasks.md",
          obsidian_name = "obsidian_jjuchara",
        },
        {
          name = "frontend",
          alias = "Frontend",
          path = "/Users/jjuchara/projects/topSystems/docAsCode/РАЗРАБОТКА/Frontend/Tasks/Tasks.md",
        },
      },
      view = {
        type = "float",
        width = 0.5,
        height = 0.5,
        repository_mode = "tabs",
        status = "active",
      },
      mappings = {
        open = "<leader>to",
        create = "<leader>ta",
      },
    },
  },
}
