return {
  {
    "jjuchara/obsidian-tasks.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      repositories = {
        {
          name = "personal",
          alias = "Personal",
          vault = "~/Documents/MySecondBrain",
          todo_file = "Tasks/Tasks.md",
          obsidian_name = "obsidian_jjuchara",
          sources = {
            {
              glob = "1. Projects/**/*.md",
              tags = { "#project" },
              project_tag = {
                root = "1. Projects",
                marker = "#projects",
                exclude = { "#projects", "#project-support" },
              },
            },
          },
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
        open = "<leader>oo",
        create = "<leader>oc",
      },
    },
  },
}
