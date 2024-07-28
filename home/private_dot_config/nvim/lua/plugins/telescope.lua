return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6",
  -- or                              , branch = '0.1.x',
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>fh",
      desc = "Find files (omit NPM packages)",
      function()
        require("telescope.builtin").find_files({
          hidden = true,
          find_command = {
            "rg",
            "--files",
            "--hidden",
            "--glob=!.git/**",
            "--glob=!node_modules/**",
            "--glob=!.vscode/",
            "--glob=!temp/",
            "--glob=!.next/**",
          },
        })
      end,
      { noremap = true, silent = true },
    },
    {
      "<leader>s.",
      desc = "Grep root dir (omit NPM packages)",
      function()
        require("telescope.builtin").live_grep({
          additional_args = function()
            return { "--hidden" }
          end,
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--glob=!.git/**",
            "--glob=!node_modules/**",
            "--glob=!tmp/**",
            "--glob=!.vscode/",
            "--glob=!.next/**",
          },
        })
      end,
      { noremap = true, silent = true },
    },
  },
}
