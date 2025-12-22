return {
  "scottmckendry/cyberdream.nvim",
  lazy = false,
  priority = 1000,

  config = function()
    require("cyberdream").setup({
      transparent = true,
      italic_comments = true,

      saturation = 1,

      colors = {
        bg = "#160D13",
        bg_alt = "#24121D",
        bg_highlight = "#38202D",
        fg = "#FFF1F0",
        grey = "#B09AA5",

        -- Main accent: vivid ember orange
        orange = "#FF9E45",
        yellow = "#FFD166",

        -- Rose and plum
        red = "#FF5470",
        pink = "#FF789F",
        magenta = "#F28CBB",
        purple = "#C792EA",

        -- Supporting colors
        blue = "#91BFFF",
        cyan = "#72DDE0",
        green = "#A6E3A1",
      },

      highlights = {
        -- Text and editor details
        Normal = { fg = "#FFF1F0", bg = "NONE" },
        NormalNC = { fg = "#E8D5DD", bg = "NONE" },
        NormalFloat = { fg = "#FFF1F0", bg = "NONE" },

        NonText = { fg = "#A87588" },
        SpecialKey = { fg = "#FF9E45" },
        Whitespace = { fg = "#87576B" },
        EndOfBuffer = { fg = "#87576B" },

        LineNr = { fg = "#B09AA5" },
        CursorLineNr = { fg = "#FF9E45", bold = true },
        CursorLine = { bg = "#24121D" },
        SignColumn = { bg = "NONE" },
        FoldColumn = { fg = "#B09AA5", bg = "NONE" },

        -- Syntax
        Comment = { fg = "#B09AA5", italic = true },
        String = { fg = "#A6E3A1" },
        Character = { fg = "#A6E3A1" },
        Number = { fg = "#FFD166" },
        Boolean = { fg = "#FF789F", bold = true },
        Constant = { fg = "#FFB86C" },

        Function = { fg = "#FF9E45", bold = true },
        Keyword = { fg = "#F28CBB", italic = true },
        Statement = { fg = "#FF789F" },
        Conditional = { fg = "#FF789F" },
        Operator = { fg = "#FFB86C" },
        Type = { fg = "#91BFFF" },
        Identifier = { fg = "#FFF1F0" },
        Special = { fg = "#FFD166" },
        PreProc = { fg = "#C792EA" },

        -- Treesitter
        ["@variable"] = { fg = "#FFF1F0" },
        ["@variable.builtin"] = { fg = "#FF789F" },
        ["@property"] = { fg = "#F2C6D4" },
        ["@parameter"] = { fg = "#FFB86C", italic = true },
        ["@function"] = { fg = "#FF9E45", bold = true },
        ["@function.call"] = { fg = "#FFB86C" },
        ["@keyword"] = { fg = "#F28CBB", italic = true },
        ["@keyword.return"] = { fg = "#FF5470", bold = true },
        ["@string"] = { fg = "#A6E3A1" },
        ["@type"] = { fg = "#91BFFF" },
        ["@constant"] = { fg = "#FFD166" },
        ["@tag"] = { fg = "#FF789F" },
        ["@tag.attribute"] = { fg = "#FFB86C" },

        -- Selection and search
        Visual = { bg = "#593044" },
        Search = { fg = "#160D13", bg = "#FFD166", bold = true },
        IncSearch = { fg = "#160D13", bg = "#FF9E45", bold = true },

        -- File explorers
        NvimTreeNormal = { fg = "#FFF1F0", bg = "NONE" },
        NvimTreeNormalNC = { fg = "#E8D5DD", bg = "NONE" },
        NvimTreeEndOfBuffer = { fg = "#87576B", bg = "NONE" },
        NvimTreeSignColumn = { bg = "NONE" },
        NvimTreeWinSeparator = { fg = "#87576B", bg = "NONE" },
        NvimTreeRootFolder = { fg = "#FF9E45", bold = true },
        NvimTreeFolderIcon = { fg = "#FF9E45" },
        NvimTreeFolderName = { fg = "#F2C6D4" },
        NvimTreeOpenedFolderName = { fg = "#FF9E45", bold = true },
        NvimTreeGitNew = { fg = "#A6E3A1" },
        NvimTreeGitDirty = { fg = "#FFD166" },
        NvimTreeGitDeleted = { fg = "#FF5470" },

        NeoTreeNormal = { fg = "#FFF1F0", bg = "NONE" },
        NeoTreeNormalNC = { fg = "#E8D5DD", bg = "NONE" },
        NeoTreeEndOfBuffer = { fg = "#87576B", bg = "NONE" },
        NeoTreeWinSeparator = { fg = "#87576B", bg = "NONE" },

        -- Completion menus and borders
        Pmenu = { fg = "#FFF1F0", bg = "#24121D" },
        PmenuSel = {
          fg = "#160D13",
          bg = "#FF9E45",
          bold = true,
        },
        PmenuSbar = { bg = "#38202D" },
        PmenuThumb = { bg = "#FF9E45" },
        FloatBorder = { fg = "#A87588", bg = "NONE" },
        WinSeparator = { fg = "#87576B", bg = "NONE" },
        VertSplit = { fg = "#87576B", bg = "NONE" },

        -- Diagnostics
        DiagnosticError = { fg = "#FF5470" },
        DiagnosticWarn = { fg = "#FFD166" },
        DiagnosticInfo = { fg = "#91BFFF" },
        DiagnosticHint = { fg = "#72DDE0" },
        DiagnosticOk = { fg = "#A6E3A1" },

        -- Git signs
        GitSignsAdd = { fg = "#A6E3A1" },
        GitSignsChange = { fg = "#FFB86C" },
        GitSignsDelete = { fg = "#FF5470" },
      },
    })

    vim.cmd.colorscheme("cyberdream")
  end,
}
