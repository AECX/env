return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          -- clangd uses .clang-format automatically
        },
      },
    },
  },
}
