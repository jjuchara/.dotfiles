return {
  "is0n/jaq-nvim",
  init = function()
    require("jaq-nvim").setup {
      cmds = {
        -- Default UI used (see `Usage` for options)
        default = "term",
        -- Uses external commands such as 'g++' and 'cargo'
        external = {
          typescript = "deno run %",
          javascript = "node %",
          markdown = "glow %",
          python = "python3 %",
          -- rust = "rustc % && ./$fileBase && rm $fileBase",
          rust = "cargo run",
          cpp = "g++ % -o $fileBase && ./$fileBase",
          go = "go run %",
          sh = "sh %",
        },
        -- Uses internal commands such as 'source' and 'luafile'
        internal = {
          -- lua = "luafile %",
          -- vim = "source %",
        },
      },

      behavior = {
        -- Default type
        default = "quickfix",
        -- Start in insert mode
        startinsert = false,
        -- Use `wincmd p` on startup
        wincmd = false,
        -- Auto-save files
        autosave = false,
      },

      -- UI settings
      ui = {
        -- Floating Window / FTerm settings
        float = {
          -- Floating window border (see ':h nvim_open_win')
          border = "none",
          -- Num from `0 - 1` for measurements
          height = 0.8,
          width = 0.8,
          x = 0.5,
          y = 0.5,
          -- Highlight group for floating window/border (see ':h winhl')
          border_hl = "FloatBorder",
          float_hl = "Normal",
          -- Floating Window Transparency (see ':h winblend')
          blend = 0,
        },
        terminal = {
          -- Position of terminal
          position = "bot",
          -- Open the terminal without line numbers
          line_no = false,
          -- Size of terminal
          size = 60,
        },
      },
    }
  end,
  keys = {
    { "<leader>:", "<cmd>Jaq<cr>", desc = "Code runner" },
  },
}
