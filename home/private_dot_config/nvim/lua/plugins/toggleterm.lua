return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      local toggleterm = require("toggleterm")
      toggleterm.setup({
        open_mapping = [[<c-t>]],
      })
    end,
  },
}
