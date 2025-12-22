return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters = opts.formatters or {}

      opts.formatters_by_ft.c = { "clang_format" }
      opts.formatters_by_ft.cpp = { "clang_format" }
      opts.formatters_by_ft.php = { "php_cs_fixer" }

      -- C#: use the Roslyn LSP formatter
      opts.formatters_by_ft.cs = {
        lsp_format = "prefer",
        filter = function(client)
          return client.name == "roslyn" or client.name == "roslyn_ls"
        end,
      }

      local function find_project_root(filename)
        local dir = vim.fs.dirname(vim.fs.normalize(filename))

        while dir do
          if vim.fn.filereadable(dir .. "/.php-cs-fixer.php") == 1 then
            return dir
          end

          local parent = vim.fs.dirname(dir)
          if parent == dir then
            break
          end

          dir = parent
        end

        return vim.fn.getcwd()
      end

      opts.formatters.php_cs_fixer = {
        command = vim.fn.stdpath("data") .. "/mason/bin/php-cs-fixer",
        args = function(_, ctx)
          local root = find_project_root(ctx.filename)

          return {
            "fix",
            "--config=" .. root .. "/.php-cs-fixer.php",
            "--using-cache=no",
            "--",
            ctx.filename,
          }
        end,
        stdin = false,
        cwd = function(_, ctx)
          return find_project_root(ctx.filename)
        end,
      }
    end,
  },
}
