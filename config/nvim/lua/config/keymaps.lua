-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local dap = require("dap")

-- Configure netcoredbg adapter
dap.adapters.coreclr = {
  type = "executable",
  command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
  args = { "--interpreter=vscode" },
}

-- Find the compiled DLL
local function find_dll()
  local cwd = vim.fn.getcwd()
  local dlls = vim.fn.glob(cwd .. "/bin/Debug/net*/*.dll", false, true)

  if #dlls > 0 then
    return dlls[1]
  end

  return nil
end

-- Configure C# debugging
dap.configurations.cs = {
  {
    type = "coreclr",
    name = "Launch - NetCoreDbg",
    request = "launch",
    program = find_dll,
    externalTerminal = true,
  },
}

-- Build visibly in a terminal, then launch the debugger on success
local function build_and_debug()
  local cwd = vim.fn.getcwd()
  local project = vim.fn.expand("~/imeso/fhir-api-rework")
  local is_fhir = vim.fn.resolve(cwd) == vim.fn.resolve(project)

  local command
  if is_fhir then
    command = { "bash", "scripts/build.sh" }
  else
    command = { "dotnet", "build" }
  end

  -- Open a dedicated terminal split
  vim.cmd("botright 15new")
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()

  vim.api.nvim_buf_set_name(buf, "Build Output")

  vim.notify("Running: " .. table.concat(command, " "), vim.log.levels.INFO)

  -- Run asynchronously; output appears live in the terminal
  local job = vim.fn.termopen(command, {
    cwd = cwd,

    on_exit = function(_, exit_code)
      vim.schedule(function()
        if exit_code == 0 then
          vim.notify("Build succeeded!", vim.log.levels.INFO)

          -- Close the build terminal on success
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
          end

          -- Start the debugger for the .NET build
          if not is_fhir then
            dap.continue()
          end
        else
          vim.notify(
            "Build failed (exit code " .. exit_code .. "). Inspect the Build Output terminal.",
            vim.log.levels.ERROR
          )

          -- Keep the terminal open so errors remain visible
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_set_current_win(win)
          end
        end
      end)
    end,
  })

  if job <= 0 then
    vim.notify("Failed to start build process.", vim.log.levels.ERROR)
    return
  end

  -- Enter terminal insert mode to display live output
  vim.cmd("startinsert")
end

-- Use uppercase D to preserve LazyVim's <leader>cd
vim.keymap.set("n", "<leader>cD", build_and_debug, {
  desc = "Build & Debug",
  noremap = true,
  silent = true,
})
