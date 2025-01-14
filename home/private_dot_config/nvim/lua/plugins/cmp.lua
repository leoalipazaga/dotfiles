return {
  {
    "hrsh7th/nvim-cmp",
    -- lazy = false,
    -- priority = 100,
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
      "saadparwaiz1/cmp_luasnip",
      "roobert/tailwindcss-colorizer-cmp.nvim",
      -- "zbirenbaum/copilot.lua",
      -- "zbirenbaum/copilot-cmp",
    },
    config = function()
      vim.opt.completeopt = { "menu", "menuone", "noselect" }
      vim.opt.shortmess:append("c")

      local lspkind = require("lspkind")
      lspkind.init({
        symbol_map = {
          Copilot = "",
        },
      })

      local kind_formatter = lspkind.cmp_format({
        mode = "symbol_text",
        maxwidth = 50,
        ellipsis_char = "...",
        menu = {
          buffer = "[buf]",
          nvim_lsp = "[LSP]",
          nvim_lua = "[api]",
          path = "[path]",
          luasnip = "[snip]",
          gh_issues = "[issues]",
          tn = "[TabNine]",
          eruby = "[erb]",
        },
      })

      -- Add tailwindcss-colorizer-cmp as a formatting source
      require("tailwindcss-colorizer-cmp").setup({
        color_square_width = 2,
      })

      local cmp = require("cmp")

      cmp.setup({
        sources = {
          {
            name = "lazydev",
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
        },
        mapping = {
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-y>"] = cmp.mapping(
            cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            }),
            { "i", "c" }
          ),
          ["<C-Space>"] = cmp.mapping.complete({}),          -- show completion suggestions
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),           -- scroll up preview
          ["<C-d>"] = cmp.mapping.scroll_docs(4),            -- scroll down preview
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- scroll down preview
          ["<C-c"] = cmp.mapping.close(),                    -- close completion suggestions
          ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        },

        -- Enable luasnip to handle snippet expansion for nvim-cmp
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },

        formatting = {
          fields = { "abbr", "kind", "menu" },
          expandable_indicator = true,
          format = function(entry, vim_item)
            -- Lspkind setup for icons
            vim_item = kind_formatter(entry, vim_item)

            -- Tailwind colorizer setup
            vim_item = require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)

            return vim_item
          end,
        },

        sorting = {
          priority_weight = 2,
          comparators = {
            -- require("copilot_cmp.comparators").prioritize,

            -- Below is the default comparitor list and order for nvim-cmp
            cmp.config.compare.offset,
            -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        window = {
          -- TODO: I don't like this at all for completion window, it takes up way too much space.
          --  However, I think the docs one could be OK, but I need to fix the highlights for it
          --
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
      })
    end,
  },
}

-- return {
--   {
--     "L3MON4D3/LuaSnip",
--     keys = function()
--       return {}
--     end,
--   },
--   {
--     "hrsh7th/nvim-cmp",
--     dependencies = {
--       "hrsh7th/cmp-emoji",
--     },
--     ---@param opts cmp.ConfigSchema
--     opts = function(_, opts)
--       local has_words_before = function()
--         unpack = unpack or table.unpack
--         local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--         return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
--       end
--
--       local luasnip = require("luasnip")
--       local cmp = require("cmp")
--
--       opts.mapping = vim.tbl_extend("force", opts.mapping, {
--         ["<Tab>"] = cmp.mapping(function(fallback)
--           if cmp.visible() then
--             cmp.select_next_item()
--             -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
--             -- this way you will only jump inside the snippet region
--           elseif luasnip.expand_or_jumpable() then
--             luasnip.expand_or_jump()
--           elseif has_words_before() then
--             cmp.complete()
--           else
--             fallback()
--           end
--         end, { "i", "s" }),
--         ["<S-Tab>"] = cmp.mapping(function(fallback)
--           if cmp.visible() then
--             cmp.select_prev_item()
--           elseif luasnip.jumpable(-1) then
--             luasnip.jump(-1)
--           else
--             fallback()
--           end
--         end, { "i", "s" }),
--       })
--     end,
--   },
-- }
