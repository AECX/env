return {
  {
    "seblyng/roslyn.nvim",
    ft = { "cs" },
    opts = {},
    -- init, not config: the plugin starts the client as soon as it loads, before config runs
    init = function()
      vim.lsp.config("roslyn", {
        -- The plugin's default cmd minus --daemon-mode. A daemon outlives nvim and is shared
        -- between sessions, so it ignores cmd_env unless this client happened to spawn it.
        cmd = {
          vim.fn.stdpath("data") .. "/mason/bin/roslyn-language-server",
          "--stdio",
          "--clientProcessId",
          tostring(vim.uv.os_getpid()),
          "--extensionLogDirectory",
          vim.fn.stdpath("log") .. "/roslyn",
        },
        cmd_env = {
          CustomAfterMicrosoftCommonTargets = vim.fn.stdpath("config") .. "/msbuild/roslyn-design-time.targets",
        },
      })
    end,
  },
  -- roslyn.nvim enables its own "roslyn" client, so turn off the other C# servers:
  -- omnisharp comes from LazyVim's lang.dotnet extra, and roslyn_ls is enabled by
  -- mason-lspconfig because the roslyn-language-server package is installed.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        omnisharp = { enabled = false },
        roslyn_ls = { enabled = false },
      },
    },
  },
}
