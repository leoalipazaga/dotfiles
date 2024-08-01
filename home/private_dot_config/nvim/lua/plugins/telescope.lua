return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6",
  -- or                              , branch = '0.1.x',
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-file-browser.nvim" },
  keys = {
    {
      "<leader>fP",
      desc = "Find Plugin file",
      function()
        require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
      end,
    },
    {
      ";f",
      desc = "",
      function()
        local builtin = require("telescope.builtin")
        builtin.find_files({
          hidden = true,
          no_ignore = false,
        })
      end,
    },
    {
      ";r",
      desc = "Find Live Grep",
      function()
        local builtin = require("telescope.builtin")
        builtin.live_grep()
      end,
    },
    {
      "\\\\",
      desc = "Find buffers",
      function()
        local builtin = require("telescope.builtin")
        builtin.buffers()
      end,
    },
    {
      ";t",
      desc = "Help tags",
      function()
        local builtin = require("telescope.builtin")
        builtin.help_tags()
      end,
    },
    {
      ";;",
      desc = "Resume",
      function()
        local builtin = require("telescope.builtin")
        builtin.resume()
      end,
    },
    {
      ";e",
      desc = "Diagnostics",
      function()
        local builtin = require("telescope.builtin")
        builtin.diagnostics()
      end,
    },
    {
      ";s",
      desc = "Treesitter",
      function()
        local builtin = require("telescope.builtin")
        builtin.treesitter()
      end,
    },
    {
      "sf",
      desc = "Telescope Browser",
      function()
        local telescope = require("telescope")
        local function telescope_buffer_dir()
          return vim.fn.expand("%:p:h")
        end
        telescope.extensions.file_browser.file_browser({
          cwd = telescope_buffer_dir(),
          path = "%:p:h",
          respect_gitignore = false,
          hidden = true,
          grouped = true,
          previewer = false,
          initial_mode = "normal",
          layout_config = { height = 40 },
        })
      end,
    },
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
  config = function(_, opts)
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local fb_actions = require("telescope").extensions.file_browser.actions
    opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
      wrap_results = true,
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "top" },
      sorting_strategy = "ascending",
      winblend = 0,
      mapping = {
        n = {},
      },
    })
    opts.pickers = {
      diagnostics = {
        theme = "ivy",
        initial_mode = "normal",
        layout_config = {
          preview_cutoff = 9999,
        },
      },
    }
    opts.extensions = {
      file_browser = {
        theme = "dropdown",
        -- disable netwr and use telescope-file-browser in its place
        hijack_netwr = true,
        mappings = {
          ["n"] = {
            -- your custom normal mode
            ["N"] = fb_actions.create,
            ["h"] = fb_actions.goto_parent_dir,
            ["/"] = function()
              vim.cmd("startinsert")
            end,
            ["<C-u>"] = function(prompt_bufnr)
              for i = 1, 10 do
                actions.move_selection_previous(prompt_bufnr)
              end
            end,
            ["<C-d>"] = function(prompt_bufnr)
              for i = 1, 10 do
                actions.move_selection_next(prompt_bufnr)
              end
            end,
            ["<PageUp>"] = actions.preview_scrolling_up,
            ["<PageDown>"] = actions.preview_scrolling_down,
          },
        },
      },
    }
    telescope.setup(opts)
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("file_browser")
  end,
}
