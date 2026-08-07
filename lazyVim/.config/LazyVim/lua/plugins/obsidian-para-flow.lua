return {
  {
    "jjuchara/nvim-obsidian-para-flow",
    version = "*",
    opts = {
      vault = "MySecondBrain",
      inbox = {
        folder = "6. Inbox",
        quickadd_choice = "inbox",
      },
      capture = {
        profiles = {
          idea = {
            label = "Idea",
            folder = "1. Projects/obsidian para flow",
            quickadd_choice = "idea",
          },
          project = {
            label = "Project",
            folder = "1. Projects",
            quickadd_choice = "project",
          },
          area = {
            label = "Area",
            folder = "2. Areas",
            quickadd_choice = "areas",
          },
          resource = {
            label = "Resource",
            folder = "3. Resources",
            quickadd_choice = "resources",
          },
        },
      },
      mappings = {
        new_with_task = "<leader>oN",
      },
      para = {
        projects = { folder = "1. Projects", link = "[[My Projects]]" },
        areas = { folder = "2. Areas", link = "[[My Areas]]" },
        resources = { folder = "3. Resources" },
        archives = { folder = "4. Archives" },
      },
    },
  },
}
