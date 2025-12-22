return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers["*"] = opts.servers["*"] or {}

      local keys = opts.servers["*"].keys or {}
      opts.servers["*"].keys = keys

      -- Remove LazyVim's default gr mapping
      for i = #keys, 1, -1 do
        if keys[i][1] == "gr" then
          table.remove(keys, i)
        end
      end

      -- Rename symbol
      keys[#keys + 1] = {
        "grn",
        vim.lsp.buf.rename,
        desc = "Rename Symbol",
        has = "rename",
      }

      -- Show references using the Snacks picker
      keys[#keys + 1] = {
        "grr",
        function()
          Snacks.picker.lsp_references()
        end,
        desc = "Show References",
        nowait = true,
        has = "references",
      }
    end,
  },
}
