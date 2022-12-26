return require("telescope").register_extension({
	setup = function(_, _) end,
	exports = {
		list = require "telescope._extensions.knowledge_base.list",
	},
})
