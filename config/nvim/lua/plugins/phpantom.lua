return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        phpantom_lsp = {
          flags = {
            debounce_text_changes = 100,
          },
        },
      },
    },
  },
}
