require("lspconfig").clangd.setup{
    cmd = {
        "clangd",
        "--compile-commands-dir=build"
    },
    filetypes = { "c", "cpp", "objc", "objcpp" },
}
