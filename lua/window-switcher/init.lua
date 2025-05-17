local M = {}

local function show_number(win, number)
	local buf = vim.api.nvim_create_buf(false, true)
	local width = vim.api.nvim_win_get_width(win)
	local height = vim.api.nvim_win_get_height(win)

	local box_height = 3
	local box_width = 6
	local opts = {
		relative = "win",
		win = win,
		width = box_width,
		height = box_height,
		row = math.floor((height - box_height) / 2),
		col = math.floor((width - box_width) / 2),
		style = "minimal",
		border = "bold",
	}

	local text = {}
	for _ = 1, math.floor(box_height / 2) do
		table.insert(text, "")
	end
	table.insert(text, string.format(string.format("%%%dd", math.floor(box_width / 2)), number))
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, text)
	local float_win = vim.api.nvim_open_win(buf, false, opts)

	return float_win
end


function M.pick_window()
	local windows = vim.api.nvim_list_wins()
	local current = vim.api.nvim_get_current_win()

	local win_map = {}
	local floats = {}

	for i, win in ipairs(windows) do
		win_map[tostring(i)] = win
		local float = show_number(win, i)
		table.insert(floats, float)
	end

	vim.cmd.redraw()
	vim.cmd.echo"'Window switcher: '"

	local ok, char = pcall(vim.fn.getchar)

	for _, win in ipairs(floats) do
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end

	if not ok then
		print("Input cancelled!")
		return
	end

	local key = type(char) == "number" and vim.fn.nr2char(char) or char
	local target = win_map[key]

	if target and target ~= current then
		vim.api.nvim_set_current_win(target)
	elseif target == current then
		-- Pass.
	else
		vim.notify("'Not a valid window.'", vim.log.levels.WARN)
	end
end

return M
