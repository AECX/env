return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      events = {
        "BufReadPost",
        "BufNewFile",
        "BufWritePost",
        "InsertLeave",
      },
      linters_by_ft = {
        php = { "phpcs" },
      },
    },
  },
}
