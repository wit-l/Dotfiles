-- Port of UseLinuxTools.ps1 for Clink (cmd.exe).
-- elt / EnableLinuxTools : append %GIT%\usr\bin to PATH
-- dlt / DisableLinuxTools: remove %GIT%\usr\bin from PATH

local function git_usr_bin()
	local git = os.getenv("GIT")
	if not git or git == "" then
		return nil
	end
	git = git:gsub("[/\\]+$", "")
	return git .. "\\usr\\bin"
end

local function split_path(path)
	local parts = {}
	for part in string.gmatch(path or "", "[^;]+") do
		if part ~= "" then
			table.insert(parts, part)
		end
	end
	return parts
end

local function path_index_of(parts, target)
	local target_lower = target:lower()
	for i, part in ipairs(parts) do
		if part:lower() == target_lower then
			return i
		end
	end
	return -1
end

local function enable_linux_tools()
	local usr_bin = git_usr_bin()
	if not usr_bin then
		print("GIT environment variable is not set.")
		return
	end
	local parts = split_path(os.getenv("PATH"))
	if path_index_of(parts, usr_bin) == -1 then
		table.insert(parts, usr_bin)
		os.setenv("PATH", table.concat(parts, ";"))
	end
end

local function disable_linux_tools()
	local usr_bin = git_usr_bin()
	if not usr_bin then
		return
	end
	local parts = split_path(os.getenv("PATH"))
	local filtered = {}
	local target_lower = usr_bin:lower()
	for _, part in ipairs(parts) do
		if part:lower() ~= target_lower then
			table.insert(filtered, part)
		end
	end
	os.setenv("PATH", table.concat(filtered, ";"))
end

local commands = {
	elt = enable_linux_tools,
	enablelinuxtools = enable_linux_tools,
	dlt = disable_linux_tools,
	disablelinuxtools = disable_linux_tools,
}

local function onfilterinput(line)
	local cmd = line:match("^%s*(%S+)")
	if not cmd then
		return
	end
	local handler = commands[cmd:lower()]
	if not handler then
		return
	end
	handler()
	return "", false
end

if clink.onfilterinput then
	clink.onfilterinput(onfilterinput)
else
	print("LinuxTools.lua requires a newer version of Clink; please upgrade.")
end
