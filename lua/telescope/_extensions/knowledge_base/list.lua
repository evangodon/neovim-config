local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

-- TODO:: Pass in path via some config
local KB_PATH = "~/notes/knowledge-base/computers/"

local function kb_files()
	local files_list = {}
	local output = vim.fn.system("ls " .. KB_PATH)
	for line in string.gmatch(output, "[^\n]+") do
		table.insert(files_list, { line, KB_PATH .. line })
	end
	return files_list
end

return function(opts)
	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "Knowledge Base",
			finder = finders.new_table({
				results = kb_files(),
				entry_maker = function(entry)
					return {
						value = entry[2],
						display = entry[1],
						ordinal = entry[1],
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			previewer = conf.file_previewer(opts),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					vim.api.nvim_command("edit " .. selection.value)
				end)
				return true
			end,
		})
		:find()
end
