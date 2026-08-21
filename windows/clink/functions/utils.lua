-- General utilities for Clink (cmd.exe).
-- mkcd <dir>   : create directory if missing, then cd into it
-- which <name> : resolve doskey alias, Lua command, builtin, or path

local function trim(s)
	return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function first_arg(rest)
	rest = trim(rest or "")
	if rest == "" then
		return nil
	end
	local quoted = rest:match('^"(.-)"')
	if quoted then
		return quoted
	end
	return rest:match("^(%S+)")
end

local function quote_cmd(s)
	return '"' .. tostring(s):gsub('"', "") .. '"'
end

--------------------------------------------------------------------------------
-- mkcd

local function mkcd(rest)
	local dir = first_arg(rest)
	if not dir then
		print("用法: mkcd <dir>")
		return "", false
	end
	return "mkdir " .. quote_cmd(dir) .. " 2>nul & cd /d " .. quote_cmd(dir), false
end

--------------------------------------------------------------------------------
-- which

-- Clink Lua commands registered across functions/*.lua
local lua_commands = {
	mkcd = true,
	which = true,
	["set-proxy"] = true,
	["clear-proxy"] = true,
	["enable-linux-tools"] = true,
	["disable-linux-tools"] = true,
}

-- CMD.exe internal commands (ss64.com/nt/syntax-internal.html)
local cmd_builtins = {
	assoc = true,
	["break"] = true,
	call = true,
	cd = true,
	chdir = true,
	cls = true,
	color = true,
	copy = true,
	date = true,
	del = true,
	dir = true,
	dpath = true,
	echo = true,
	endlocal = true,
	erase = true,
	exit = true,
	["for"] = true,
	ftype = true,
	["goto"] = true,
	["if"] = true,
	keys = true,
	md = true,
	mkdir = true,
	mklink = true,
	move = true,
	path = true,
	pause = true,
	popd = true,
	prompt = true,
	pushd = true,
	rd = true,
	rem = true,
	ren = true,
	rename = true,
	rmdir = true,
	set = true,
	setlocal = true,
	shift = true,
	start = true,
	time = true,
	title = true,
	type = true,
	ver = true,
	verify = true,
	vol = true,
}

local function is_lua_command(name)
	return lua_commands[name:lower()] == true
end

local function is_cmd_builtin(name)
	return cmd_builtins[name:lower()] == true
end

local function where_paths(name)
	local paths = {}
	local f = io.popen("where.exe " .. quote_cmd(name) .. " 2>nul")
	if not f then
		return paths
	end
	for line in f:lines() do
		if line ~= "" then
			table.insert(paths, line)
		end
	end
	f:close()
	return paths
end

local function which_resolve(name, seen)
	seen = seen or {}
	local key = name:lower()
	if seen[key] then
		return name
	end
	seen[key] = true

	local alias = os.getalias and os.getalias(name)
	if alias and alias ~= "" then
		local target = alias:match('^"([^"]+)"') or alias:match("^(%S+)") or alias
		return which_resolve(target, seen)
	end

	if is_lua_command(name) then
		return name .. " (Clink Lua command)"
	end

	if is_cmd_builtin(name) then
		return name .. " (CMD internal command)"
	end

	local paths = where_paths(name)
	if paths[1] then
		return paths[1]
	end
	return name
end

local function which_cmd(rest)
	local name = first_arg(rest)
	if not name then
		print("用法: which <name>")
		return "", false
	end

	local alias = os.getalias and os.getalias(name)
	if alias and alias ~= "" then
		print(string.format("%s: Alias for (%s)", name, which_resolve(name)))
		return "", false
	end

	if is_lua_command(name) then
		print(name .. ": Clink Lua command")
		return "", false
	end

	if is_cmd_builtin(name) then
		print(name .. ": CMD internal command")
		return "", false
	end

	local paths = where_paths(name)
	if #paths > 0 then
		for _, p in ipairs(paths) do
			print(p)
		end
		return "", false
	end

	print(name .. ": not found")
	return "", false
end

--------------------------------------------------------------------------------

local commands = {
	mkcd = mkcd,
	which = which_cmd,
}

local function onfilterinput(line)
	local cmd, rest = line:match("^%s*(%S+)(.*)$")
	if not cmd then
		return
	end
	local handler = commands[cmd:lower()]
	if not handler then
		return
	end
	return handler(rest)
end

if clink.onfilterinput then
	clink.onfilterinput(onfilterinput)
else
	print("utils.lua requires a newer version of Clink; please upgrade.")
end
