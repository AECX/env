-- Where compile_commands.json lives is up to each project: a .clangd file
-- in its root (CompileFlags: CompilationDatabase: <dir>), or clangd's own
-- search of the source file's parent directories and their build/ folders.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          filetypes = { "c", "cpp", "objc", "objcpp" },
        },
      },
    },
  },
}
