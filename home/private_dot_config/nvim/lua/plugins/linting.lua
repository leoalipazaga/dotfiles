-- TODO: Remove linting after refactor lsp linting
if true then
  return {}
end

return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      local eslint = lint.linters.eslint_d
      -- HACK: https://github.com/mfussenegger/nvim-lint/issues/462#issuecomment-1986702915
      eslint.args = {
        "--no-warn-ignored", -- <-- this is the key argument
        "--format",
        "json",
        "--stdin",
        "--stdin-filename",
        function()
          return vim.api.nvim_buf_get_name(0)
        end,
      }

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        -- astro = { "eslint_d" },
        svelte = { "eslint_d" },
        -- go = { "golangci-lint" },
      }

      local lint_group = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        -- pattern = { "*.ts", "*.js" },
        group = lint_group,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
