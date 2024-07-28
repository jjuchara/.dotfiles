return {
  {
    "renerocksai/telekasten.nvim",
    config = function()
      local home = vim.fn.expand("~/projects/Notes")
      require("telekasten").setup({
        home = home,
        take_over_my_home = true,
        auto_set_filetype = true,

        -- dir names for special notes (absolute path or subdir name)
        dailies = home .. "/" .. "journal",
        -- weeklies     = home .. '/' .. 'weekly',
        templates = home .. "/" .. "templates",

        image_subdir = "images",
        extension = ".md",

        -- Generate note filenames. One of:
        -- "title" (default) - Use title if supplied, uuid otherwise
        -- "uuid" - Use uuid
        -- "uuid-title" - Prefix title by uuid
        -- "title-uuid" - Suffix title with uuid
        new_note_filename = "title",
        -- file uuid type ("rand" or input for os.date()")
        -- uuid_type = "%Y%m%d%H%M",
        uuid_type = "%Y-%m-%d",
        -- UUID separator
        uuid_sep = "-",

        -- following a link to a non-existing note will create it
        follow_creates_nonexisting = false,
        dailies_create_nonexisting = false,
        weeklies_create_nonexisting = false,

        -- skip telescope prompt for goto_today and goto_thisweek
        journal_auto_open = false,

        -- template for new notes (new_note, follow_link)
        -- set to `nil` or do not specify if you do not want a template
        -- template_new_note = home .. '/' .. 'templates/new_note.md',
        template_new_note = nil,

        -- template for newly created daily notes (goto_today)
        -- set to `nil` or do not specify if you do not want a template
        -- template_new_daily = home .. '/' .. 'templates/daily.md',
        template_new_daily = nil,

        -- template for newly created weekly notes (goto_thisweek)
        -- set to `nil` or do not specify if you do not want a template
        -- template_new_weekly= home .. '/' .. 'templates/weekly.md',
        template_new_weekly = nil,

        -- image link style
        -- wiki:     ![[image name]]
        -- markdown: ![](image_subdir/xxxxx.png)
        image_link_style = "markdown",

        -- default sort option: 'filename', 'modified'
        sort = "filename",

        -- integrate with calendar-vim
        plug_into_calendar = true,
        calendar_opts = {
          -- calendar week display mode: 1 .. 'WK01', 2 .. 'WK 1', 3 .. 'KW01', 4 .. 'KW 1', 5 .. '1'
          weeknm = 4,
          -- use monday as first day of week: 1 .. true, 0 .. false
          calendar_monday = 1,
          -- calendar mark: where to put mark for marked days: 'left', 'right', 'left-fit'
          calendar_mark = "left-fit",
        },

        -- telescope actions behavior
        close_after_yanking = false,
        insert_after_inserting = true,

        -- tag notation: '#tag', ':tag:', 'yaml-bare'
        tag_notation = "#tag",

        -- command palette theme: dropdown (window) or ivy (bottom panel)
        command_palette_theme = "ivy",

        -- tag list theme:
        -- get_cursor: small tag list at cursor; ivy and dropdown like above
        show_tags_theme = "ivy",

        -- when linking to a note in subdir/, create a [[subdir/title]] link
        -- instead of a [[title only]] link
        subdirs_in_links = true,

        -- template_handling
        -- What to do when creating a new note via `new_note()` or `follow_link()`
        -- to a non-existing note
        -- - prefer_new_note: use `new_note` template
        -- - smart: if day or week is detected in title, use daily / weekly templates (default)
        -- - always_ask: always ask before creating a note
        template_handling = "same_as_current",

        -- path handling:
        --   this applies to:
        --     - new_note()
        --     - new_templated_note()
        --     - follow_link() to non-existing note
        --
        --   it does NOT apply to:
        --     - goto_today()
        --     - goto_thisweek()
        --
        --   Valid options:
        --     - smart: put daily-looking notes in daily, weekly-looking ones in weekly,
        --              all other ones in home, except for notes/with/subdirs/in/title.
        --              (default)
        --
        --     - prefer_home: put all notes in home except for goto_today(), goto_thisweek()
        --                    except for notes with subdirs/in/title.
        --
        --     - same_as_current: put all new notes in the dir of the current note if
        --                        present or else in home
        --                        except for notes/with/subdirs/in/title.
        new_note_location = "smart",

        -- should all links be updated when a file is renamed
        rename_update_links = true,

        -- vaults = {
        --     vault2 = {
        --         -- alternate configuration for vault2 here. Missing values are defaulted to
        --         -- default values from telekasten.
        --         -- e.g.
        --         -- home = "/home/user/vaults/personal",
        --     },
        -- },

        -- how to preview media files
        -- "telescope-media-files" if you have telescope-media-files.nvim installed
        -- "catimg-previewer" if you have catimg installed
        media_previewer = "telescope-media-files",

        -- A customizable fallback handler for urls.
        follow_url_fallback = nil,
      })
    end,
    keys = {
      { "<leader>nc", "<cmd>Telekasten show_calendar<cr>", desc = "Calendar" },
      { "<leader>nn", "<cmd>Telekasten new_note<cr>", desc = "New note" },
      { "<leader>nf", "<cmd>Telekasten find_notes<cr>", desc = "Find notes" },
      { "<leader>nF", "<cmd>Telekasten find_daily_notes<cr>", desc = "Find Jornal" },
      { "<leader>nj", "<cmd>Telekasten goto_today<cr>", desc = "Jornal" },
      { "<leader>np", "<cmd>Telekasten panel<cr>", desc = "Panel" },
      { "<leader>nt", "<cmd>Telekasten toggle_todo<cr>", desc = "Toggle Todo" },
    },
  },
  "renerocksai/calendar-vim",
  -- {
  --   "folke/which-key.nvim",
  --   opts = {
  --     defaults = {
  --       ["<leader>n"] = { name = "+Notes" },
  --     },
  --   },
  -- },
}
