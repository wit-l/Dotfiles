-- clink-fzf preview and FZF_* options (cmd/clink only; not Windows user env).
-- Clink settings (fzf.height, fzf_rg.show_preview, ...) live in clink_settings.

local function set_default(name, value)
	if os.getenv(name) == nil or os.getenv(name) == "" then
		os.setenv(name, value)
	end
end

local function command_on_path(name)
	local r = io.popen("where " .. name .. " 2>nul")
	if not r then
		return false
	end
	local line = r:read("*l")
	r:close()
	return line ~= nil and line ~= ""
end

-- Relative paths for Ctrl+T and ** Tab (dirx on PATH; install/dirx.ps1 -> C:\Software).
if command_on_path("dirx.exe") then
	set_default("FZF_CTRL_T_COMMAND", "fzf-list-files.cmd $dir")
	set_default("FZF_ALT_C_COMMAND", "fzf-list-dirs.cmd $dir")
end

local fzf_file_opts = table.concat({
	'--preview "fzf-preview.cmd {}"',
	"--preview-window right,65%,border-left",
	'--bind "ctrl-/:change-preview-window(down,50%|hidden|),ctrl-f:preview-down,ctrl-b:preview-up"',
}, " ")

set_default("CLINK_FZF_PREVIEW_SIXELS", "1")

set_default(
	"FZF_DEFAULT_OPTS",
	"--border=rounded --info=inline --scrollbar=▌"
)

set_default("FZF_CTRL_T_OPTS", fzf_file_opts)
set_default("FZF_COMPLETION_OPTS", fzf_file_opts)

set_default(
	"FZF_GIT_CAT",
	"bat --style=numbers,changes --color=always --pager=never"
)
