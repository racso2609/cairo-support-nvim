local utils = {}

function utils.showMessage(message)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, true, message)
	local opts = {
		relative = "cursor",
		width = 10,
		height = 2,
		col = 0,
		row = 1,
		anchor = "NW",
		style = "minimal",
	}
	local win = vim.api.nvim_open_win(buf, 0, opts)
	-- optional: change highlight, otherwise Pmenu is used
	vim.api.nvim_win_set_option(win, "winhl", "Normal:MyHighlight")
end

function utils.splitString(stringToSplit)
	local lines = {}
	for script in stringToSplit:gmatch("([^\n]*)\n?") do
		table.insert(lines, script)
	end
	return lines
end

function utils.isEqArr(arr1, arr2)
	for i = 1, #arr1 - 1 do
		if arr1[i] ~= arr2[i] then
			return false
		end
	end
	return true
end

return utils
