return {
  "scottmckendry/cyberdream.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("cyberdream").setup({
      transparent = true, -- Set to true for ultimate hacker setup over terminal background
      italic_comments = true,
    })
    vim.cmd("colorscheme cyberdream")
  end,
}
