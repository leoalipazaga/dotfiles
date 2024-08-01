-- Disabled this plugin until get know how it works
if true then
  return {}
end

return {
  "smjonas/inc-rename.nvim",
  config = function()
    require("inc_rename").setup({})
    vim.keymap.set("n", "<leader>rn", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true })
  end,
}
