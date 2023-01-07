local M = {
	"windwp/nvim-spectre",
}

function M.config()
	local spectre = require "spectre"
	spectre.setup({
		is_insert_mode = true,
		live_update = true,
		highlight = {
			ui = "String",
			search = "DiffChange",
			replace = "DiffAdd",
		},
		mapping = {
			close = {
				map = "<leader>so",
				cmd = CMD "close",
				desc = "Close",
			},
			close_2 = {
				map = "q",
				cmd = CMD "close",
				desc = "Close",
			},
			send_to_qf = {
				map = "<C-q>",
				cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
				desc = "send all item to quickfix",
			},
		},
	})
end

function M.init()
	local fn = require "user.functions"
	local spectre = require "spectre"

	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = { "spectre_panel" },
		callback = function()
			vim.bo.number = false
		end,
	})

	fn.register_key_map({
		F = {
			name = "Spectre",
			function()
				spectre.open()
			end,
			"[F]ind and Replace",
		},
	})
end

return M
