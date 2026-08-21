-- Proxy helpers for Clink (cmd.exe).
-- set-proxy <proxyUrl>  (alias: spr)
-- clear-proxy           (alias: cpr)

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

local function set_proxy(rest)
	local url = first_arg(rest)
	if not url then
		print("用法: set-proxy <proxyUrl>  (或别名 spr)")
		return "", false
	end
	if not rest:match('^%s*"') then
		url = trim(rest)
	end
	os.setenv("HTTP_PROXY", url)
	os.setenv("HTTPS_PROXY", url)
	print("代理已设置为: " .. url)
	return "", false
end

local function clear_proxy()
	os.setenv("HTTP_PROXY", nil)
	os.setenv("HTTPS_PROXY", nil)
	print("代理环境变量已清除。")
	return "", false
end

local commands = {
	["set-proxy"] = set_proxy,
	["clear-proxy"] = clear_proxy,
}

local function alias_target(name)
	local alias = os.getalias and os.getalias(name)
	if not alias or alias == "" then
		return nil
	end
	return alias:match('^"([^"]+)"') or alias:match("^(%S+)")
end

local function onfilterinput(line)
	local cmd, rest = line:match("^%s*(%S+)(.*)$")
	if not cmd then
		return
	end
	local handler = commands[cmd:lower()]
	if not handler then
		local target = alias_target(cmd)
		if target then
			handler = commands[target:lower()]
		end
	end
	if not handler then
		return
	end
	return handler(rest)
end

if clink.onfilterinput then
	clink.onfilterinput(onfilterinput)
	if register_clink_lua_command then
		register_clink_lua_command("set-proxy")
		register_clink_lua_command("clear-proxy")
	end
else
	print("proxy.lua requires a newer version of Clink; please upgrade.")
end
