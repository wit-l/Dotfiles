-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = {
	font_size = 14,
	font = wezterm.font("Maple Mono SC NF", { weight = "Regular" }),
	color_scheme = "Catppuccin Mocha",

	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	window_decorations = "INTEGRATED_BUTTONS|RESIZE",
	show_new_tab_button_in_tab_bar = false,
	window_background_opacity = 0.6,
	win32_system_backdrop = "Acrylic",

	text_background_opacity = 0.9,
	adjust_window_size_when_changing_font_size = false,
	window_padding = {
		left = 15,
		right = 0,
		top = 0,
		bottom = 0,
	},

	initial_cols = 96,
	initial_rows = 24,
	enable_scroll_bar = true,
	window_close_confirmation = "NeverPrompt",
	default_prog = { "pwsh" },
	launch_menu = {
		{
			label = "PowerShell",
			args = { "D:\\Program Files\\PowerShell\\7\\pwsh.exe" },
		},
		{
			label = "Ubuntu",
			args = { "ubuntu" },
		},
		{
			label = "Ubuntu",
			args = { "ubuntu2204" },
		},
		{
			label = "MINGW64/MSYS2",
			args = { "D:/msys64/msys2_shell.cmd", "-defterm", "-here", "-no-start", "-shell", "zsh", "-mingw64" },
		},
		{
			label = "MSYS/MSYS2",
			args = { "D:/msys64/msys2_shell.cmd", "-defterm", "-here", "-no-start", "-shell", "zsh", "-msys2" },
		},
	},
}

return config
