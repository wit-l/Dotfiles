-- clink-fzf preview and FZF_* options (cmd/clink only; not Windows user env).
-- Clink settings (fzf.height, fzf_rg.show_preview, ...) live in clink_settings.

local function set_default(name, value)
	if os.getenv(name) == nil or os.getenv(name) == "" then
		os.setenv(name, value)
	end
end

local preview_cmd = "fzf-preview.cmd {}"

local preview_opts = table.concat({
	'--preview "' .. preview_cmd .. '"',
	"--preview-window right,50%,border-left",
	'--bind "ctrl-/:change-preview-window(down,50%|hidden|)"',
}, " ")

set_default("CLINK_FZF_PREVIEW_SIXELS", "1")

set_default(
	"FZF_DEFAULT_OPTS",
	"--border=rounded --info=inline --scrollbar=▌"
)

set_default("FZF_CTRL_T_OPTS", preview_opts)
set_default("FZF_COMPLETION_OPTS", preview_opts)

set_default(
	"FZF_GIT_CAT",
	"bat --style=numbers,changes --color=always --pager=never"
)
