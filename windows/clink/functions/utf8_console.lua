-- Set cmd console to UTF-8 via Win32 API (SetConsoleCP / SetConsoleOutputCP).
-- Do not call chcp.com: first chcp 65001 in Windows Terminal resets the viewport.

local src = debug.getinfo(1, "S").source
if src:sub(1, 1) == "@" then
	src = src:sub(2)
end
local dir = src:match("^(.*)[/\\]") or "."
local exe = dir .. "\\..\\tools\\set_console_utf8.exe"

if not os.isfile or not os.isfile(exe) then
	return
end

os.execute('"' .. exe .. '"')
