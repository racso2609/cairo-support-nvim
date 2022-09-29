print("cairo")
local autocmd = vim.api.nvim_create_autocmd
local utils = require("cairo-support-nvim.utils")

function Format()
	autocmd("BufWritePost", {
		pattern = "*.cairo",
		callback = function()
			local filePath = vim.fn.expand("%:p")

			local handle = io.popen("cairo-format " .. filePath)
			if not handle then
				return
			end

			local data = handle:read("*a")
			handle:close()
			local actualContent = vim.api.nvim_buf_get_lines(0, 0, -1, false)

			local dataArr = utils.splitString(data)
			local dataIsEqToActualContent = utils.isEqArr(dataArr, actualContent)

			if not dataIsEqToActualContent then
				vim.api.nvim_buf_set_lines(0, 0, -1, false, { "" })
				vim.api.nvim_buf_set_text(0, 0, 0, 0, 0, dataArr)
				print("formated...")
			end
		end,
	})
end

function Compile()
	autocmd("BufWritePost", {
		pattern = "*.cairo",
		callback = function()
			local filePath = vim.fn.expand("%:p")
			local handle = io.popen("starknet-compile " .. filePath .. " | grep '[0-9]:*'")
			if not handle then
				return
			end
			local data = handle:read("*a")
			handle:close()
			print(data)

			-- local findData = string.gmatch(data, "*")
			-- print("compiling...")
			-- print(findData)
			-- print(data)
		end,
	})
end

local M = {}
function M.setup(config)
	if config.format then
		Format()
	end
	-- if config.compile then
	-- Compile()
	-- end
end

-- Collect all key-value pairs from the given string into a table

return M
