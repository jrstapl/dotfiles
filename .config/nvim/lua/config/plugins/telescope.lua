return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      require("telescope").setup {
        defaults = {
          preview = {
            tresitter = false,
          },
        },
        pickers = {
          find_files = {
            theme = "ivy",
          },
        },
        extensions = {
          fzf = {},
        },
      }

      require("telescope").load_extension "fzf"
      local builtin = require "telescope.builtin"
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
      vim.keymap.set("n", "<space>fh", require("telescope.builtin").help_tags)
      vim.keymap.set("n", "<space>fd", require("telescope.builtin").find_files)
      vim.keymap.set("n", "<space>en", function()
        require("telescope.builtin").find_files {
          cwd = vim.fn.stdpath "config",
        }
      end)
      vim.keymap.set("n", "<space>ep", function()
        require("telescope.builtin").find_files {
          cwd = vim.fs.joinpath(vim.fn.stdpath "data", "lazy"),
        }
      end)

      require("config.telescope.multigrep").setup()
    end,
  },
}
