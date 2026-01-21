return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local treesitter = require('nvim-treesitter')
		print(treesitter)
		require 'nvim-treesitter'.setup({})
		-- require 'nvim-treesitter'.install({ "c",
		-- 	"lua",
		-- 	"vim",
		-- 	"vimdoc",
		-- 	"query",
		-- 	"markdown",
		-- 	"markdown_inline",
		-- 	"rust",
		-- 	"python",
		-- 	"odin",
		-- 	"go",
		-- })

		vim.api.nvim_create_autocmd('FileType', {
			pattern = { "c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
				"rust",
				"python",
				"odin",
				"go",

			},
			callback = function()
				-- syntax highlighting, provided by Neovim
				vim.treesitter.start()
				-- folds, provided by Neovim (I don't like folds)
				-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
				-- vim.wo.foldmethod = 'expr'
				-- indentation, provided by nvim-treesitter
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end
}

--[[ return {
   {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require'nvim-treesitter.config'.setup {
	ensure_installed = { "c",
	"lua",
	"vim",
	"vimdoc",
	"query",
	"markdown",
	"markdown_inline",
	"rust",
	"python",
	"odin",
	"go",
	
      },
	auto_install = false,
	highlight = {
	  enable = true,
	  disable = function(lang, buf)
	    local max_filesize = 100 * 1024 -- 100 KB
	    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
	    if ok and stats and stats.size > max_filesize then
	      return true
	    end
	  end,
	  additional_vim_regex_highlighting = false,
	},
      }
    end,
  }
-- }]]
