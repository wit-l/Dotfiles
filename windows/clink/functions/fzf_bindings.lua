-- clink-fzf applies default bindings in onbeginedit (not at load).
-- Alt+B -> bash backward-word.
-- "\e?" (Alt+Shift+/) -> binding picker; replaces Clink's clink-what-is.

if not rl.setbinding then
	return
end

local function apply_fzf_binding_overrides()
	for _, keymap in ipairs({ "emacs", "vi-command", "vi-insert" }) do
		rl.setbinding([["\e?"]], [["luafunc:fzf_bindings"]], keymap)
		rl.setbinding([["\M-b"]], "backward-word", keymap)
	end
end

clink.onbeginedit(apply_fzf_binding_overrides)
