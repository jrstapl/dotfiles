return {
	{
		'echasnovski/mini.nvim',
		enabled = true,
		config = function()
			local statusline = require 'mini.statusline'
			statusline.setup { use_icons = true }

			local pairs = require 'mini.pairs'
			pairs.setup{}

			local icons = require 'mini.icons'
			icons.setup{}
		end
	},
}
