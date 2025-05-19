local M = {
	floats = {
		width = 7,
		height = 3,
		border = "bold",
	},
	ignored_buffers = {},
	ignored_windows = {
		nvim_tree = true,
		quickfix = true,
		terminal = true,
	},
}

---@param number number
---@param width number
---@param height number
---@return table
local function center_number(number, width, height)
	local num_str = tostring(number)
	local padding = math.floor((width - #num_str) / 2)
	local output = string.rep(" ", padding)
	output = output .. num_str
	local text = {}
	for _ = 1, math.floor(height / 2) do
		table.insert(text, "")
	end
	table.insert(text, output)
	return text
end


---@param win number
---@param number number
---@param opts table
---@return number
local function show_number(win, number, opts)
	opts = opts or {}

	local buf = vim.api.nvim_create_buf(false, true)
	local width = vim.api.nvim_win_get_width(win)
	local height = vim.api.nvim_win_get_height(win)

	local box_height = opts.height or 3
	local box_width = opts.width or 7

	local win_opts = {
		relative = "win",
		win = win,
		width = box_width,
		height = box_height,
		row = math.floor((height - box_height) / 2),
		col = math.floor((width - box_width) / 2),
		style = "minimal",
		border = opts.border or "bold",
	}

	local text = center_number(number, box_width, box_height)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, text)
	local float_win = vim.api.nvim_open_win(buf, false, win_opts)

	return float_win
end

function M.ignore_window(win)
	local buf = vim.api.nvim_win_get_buf(win)
	local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })

	if M.ignored_windows.nvim_tree then
		local name = vim.api.nvim_buf_get_name(buf)
		if name:match("NvimTree_") then
			return true
		end
	end

	if M.ignored_windows.quickfix then
		if buftype == "quickfix" or buftype == "qf" then
			return true
		end
	end

	if M.ignored_windows.terminal then
		if buftype == "terminal" then
			return true
		end
	end
	return false
end

function M.pick_window()
	local windows = vim.api.nvim_list_wins()
	local current = vim.api.nvim_get_current_win()

	local win_map = {}
	local floats = {}

	local count = 0
	for _, win in ipairs(windows) do
		if not M.ignore_window(win) then
			count = count + 1
			win_map[tostring(count)] = win
			local float = show_number(win, count, M.floats)
			table.insert(floats, float)
		end
	end

	vim.cmd.redraw()
	vim.cmd.echo "'Window switcher nya: '"

	local ok, char = pcall(vim.fn.getchar)

	for _, win in ipairs(floats) do
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end

	if not ok then
		print("Input cancelled nya!")
		return
	end

	local key = type(char) == "number" and vim.fn.nr2char(char) or char
	local target = win_map[key]

	if target and target ~= current then
		vim.api.nvim_set_current_win(target)
		vim.notify("Switched to window " .. tostring(key) .. " nya", vim.log.levels.INFO)
	elseif target == current then
		vim.notify("Already here nya", vim.log.levels.INFO)
	elseif key == "q" then
		vim.notify("nya~~~~~!", vim.log.levels.INFO)
	else
		vim.notify("Not a window nya", vim.log.levels.WARN)
	end
end

function M.setup(opts)
	if not opts then
		return
	end

	if opts.ignored_windows then
		M.ignore_window = opts.ignored_windows
	end

	if opts.ignored_buffers then
		M.ignored_buffers = opts.ignored_buffers
	end

	if opts.floats then
		M.floats.width = opts.floats.width or M.floats.width
		M.floats.height = opts.floats.height or M.floats.height
		M.floats.border = opts.floats.border or M.floats.border
	end
end

return M
