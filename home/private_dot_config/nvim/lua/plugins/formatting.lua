-- opts = {
--   formatters_by_ft = {
--     svelte = { "prettier" },
--   },
--   format_on_save = {
--     timeout_ms = 500,
--     lsp_fallback = true,
--   },

--    ".prettierrc.json",
--    ".prettierrc.yml",
--    ".prettierrc.yaml",
--    ".prettierrc.json5",
--    ".prettierrc.js",
--    ".prettierrc.cjs",
--    ".prettierrc.toml",
--    "prettier.config.js",
--    "prettier.config.cjs",
--    "package.json",

return {
  {
    "stevearc/conform.nvim",
    -- event = { "BufReadPre", "BufNewFile" },
    -- opts = function(_, opts)
    --   if LazyVim.has_extra("formatting.prettier") then
    --     opts.formatters_by_ft = opts.formatters_by_ft or {}
    --     opts.formatters_by_ft.astro = { "prettier" }
    --   end
    -- end,
    init = function()
      local conform = require("conform")
      conform.setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          svelte = { "prettier" },
          json = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          yaml = { "prettier" },
          graphql = { "prettier" },
          markdown = { "prettier" },
          astro = { "prettier" },
          lua = { "stylua" },
          go = { "gofmt", "goimports" },
        },
        format_on_save = {
          lsp_fallback = true,
          async = true,
          timeout_ms = 500,
        },
      })
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function(args)
          require("conform").format({ bufnr = args.buf, lsp_fallback = true })
        end,
      })
    end,
  },
}
