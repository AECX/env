return {
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      opts.sources = opts.sources or {}

      opts.sources = vim.tbl_filter(function(source)
        return source.name ~= "csharpier"
      end, opts.sources)
    end,
  },
}
