return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--compile-commands-dir=build",
          },
          filetypes = {
            "c",
            "cpp",
            "objc",
            "objcpp",
          },
        },
      },
    },
  },
}
