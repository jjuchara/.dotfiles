return {
  "MeanderingProgrammer/markdown.nvim",
  name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("render-markdown").setup({
      require("render-markdown").setup({
        -- Configure whether Markdown should be rendered by default or not
        start_enabled = true,
        -- Filetypes this plugin will run on
        file_types = { "markdown" },
        -- Vim modes that will show a rendered view of the markdown file
        -- All other modes will be uneffected by this plugin
        render_modes = { "n", "c" },
        -- Characters that will replace the # at the start of headings
        headings = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        -- Character to use for the horizontal break
        dash = "—",
        -- Character to use for the bullet points in lists
        bullets = { "●", "○", "◆", "◇" },
        checkbox = {
          -- Character that will replace the [ ] in unchecked checkboxes
          unchecked = "󰄱 ",
          -- Character that will replace the [x] in checked checkboxes
          checked = "✓",
        },
        -- Character that will replace the > at the start of block quotes
        quote = "┃",
        -- See :h 'conceallevel' for more information about meaning of values
        conceal = {
          -- conceallevel used for buffer when not being rendered, get user setting
          default = vim.opt.conceallevel:get(),
          -- conceallevel used for buffer when being rendered
          rendered = 3,
        },
        -- Add a line above and below tables to complete look, ends up like a window
        fat_tables = true,
        -- Define the highlight groups to use when rendering various components
        highlights = {
          heading = {
            -- Background of heading line
            backgrounds = {
              -- "markdownH1",
              -- "markdownH2",
              -- "markdownH3",
              -- "markdownH4",
              -- "markdownH5",
              -- "markdownH6",
              "DiffAdd",
              "DiffChange",
              "DiffDelete",
            },
            -- Foreground of heading character only
            foregrounds = {
              "markdownH1",
              "markdownH2",
              "markdownH3",
              "markdownH4",
              "markdownH5",
              "markdownH6",
            },
          },
          -- Horizontal break
          dash = "LineNr",
          -- Code blocks
          code = "ColorColumn",
          -- Bullet points in list
          bullet = "Normal",
          checkbox = {
            -- Unchecked checkboxes
            unchecked = "@markup.list.unchecked",
            -- Checked checkboxes
            checked = "@markup.heading",
          },
          table = {
            -- Header of a markdown table
            head = "@markup.heading",
            -- Non header rows in a markdown table
            row = "Normal",
          },
          -- LaTeX blocks
          latex = "@markup.math",
          -- Quote character in a block quote
          quote = "@markup.quote",
        },
      }),
    })
  end,
}
