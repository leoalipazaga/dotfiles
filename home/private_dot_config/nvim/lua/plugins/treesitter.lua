-- below configuration is overrite <C-leader> keymap
if true then
  return {}
end

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter.configs")
    treesitter.setup({
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "svelte",
        "astro",
      },
    })
  end,
}
