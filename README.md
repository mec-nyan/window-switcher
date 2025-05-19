# Window Switcher Nya!

A playful and lightweight window switcher/picker/chooser for **Neovim** that shows floating
numbers in each window so you can quickly jump between them -- with some cat-like charm!

<!-- TODO: Add screenshot here. -->

## Features

- Shows a floating number in each active window.
- (Optionally) Ignores specific window types (NvimTree, terminal, quickfix).
- Minimal and easy to configure.
- Neko-themed messages because I like cats!

## Installation

Use your favourite plugin manager. For example:


[lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
	"mec-nyan/window-switcher",
	config = function ()
		require"window-switcher".setup{}
        -- Optionally, create some key mappings.
		local switch = require"window-switcher".pick_window
		vim.keymap.set("n", "<leader>ws", switch, { desc = "Pick a window nya!"})
	end
}
```

[packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
	"mec-nyan/window-switcher",
	config = function ()
		require"window-switcher".setup{}
	end
}
```

## Usage

Call it with lua:

```lua
require"window-switcher".pick_window()
```

Or create a keymap for it:

```lua
local switch = require"window-switcher".pick_window
vim.keymap.set("n", "<leader>ws", switch, { desc = "Pick a window nya!"})
```

When invoked, each eligible window will display a floating number. Press the number to switch!

## :gear: Configuration

You can pass options to `setup` to customise the behaviour:

```lua
require"window-switcher".setup{
    floats = {
        width = 9,
        height = 5,
        border = "shadow", -- or "bold", "single", etc. See :h 'winborder'
    },
    ignored_windows = {
        nvim_tree = true,
        quickfix = true,
        terminal = true,
    },
}
```

## Options

| Option                      | Type   | Default value |              Description |
|-----------------------------|--------|--------|---------------------------------|
| `floats.width`              | number | 7      | Width of the floating window.   |
| `floats.height`             | number | 3      | Height of the floating window.  |
| `floats.border`             | string | "bold" | Border style (See `'winborder'`)|
| `ignored_windows.nvim_tree` | bool   | true   | Ignore **NvimTree** windows.    |
| `ignored_windows.quickfix`  | bool   | true   | Ignore **QuickFix** windows.    |
| `ignored_windows.terminal`  | bool   | true   | Ignore **Terminal** windows.    |


## TODO / Roadmap

- [ ] Extend support for custom filtering of window/buffers.
- [ ] Use letters (i.e. A, B, C, etc) as window labels.
- [ ] Port to **vimscript** for **Vim** users.


## Contributing

Of course, contributions are more than welcome! Feel free to open an issue or PR if you have and idea or fix.

## License

**GPL-3**


*Made with :sparkling_heart: in Neovim*
