-- Proxy helpers for Clink (cmd.exe).
-- proxy_on / proxy_off / proxy_status  (aliases: spr / cpr / gpr)

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

local function env_or_unset(name)
	local v = os.getenv(name)
	if not v or v == "" then
		return "(unset)"
	end
	return v
end

local function proxy_status()
	local names = {
		"HTTP_PROXY",
		"HTTPS_PROXY",
		"http_proxy",
		"https_proxy",
		"ALL_PROXY",
		"all_proxy",
		"NO_PROXY",
		"no_proxy",
	}
	for _, name in ipairs(names) do
		print(name .. "=" .. env_or_unset(name))
	end
	return "", false
end

local DEFAULT_PROXY = "http://127.0.0.1:7890"

local function proxy_on(rest)
	local url = first_arg(rest)
	if not url then
		url = DEFAULT_PROXY
	elseif not rest:match('^%s*"') then
		url = trim(rest)
	end
	os.setenv("HTTP_PROXY", url)
	os.setenv("HTTPS_PROXY", url)
	os.setenv("http_proxy", url)
	os.setenv("https_proxy", url)
	os.setenv("ALL_PROXY", url)
	os.setenv("all_proxy", url)
	print("proxy on: " .. url)
	return "", false
end

local function proxy_off()
	for _, name in ipairs({
		"HTTP_PROXY",
		"HTTPS_PROXY",
		"http_proxy",
		"https_proxy",
		"ALL_PROXY",
		"all_proxy",
		"NO_PROXY",
		"no_proxy",
	}) do
		os.setenv(name, nil)
	end
	print("proxy off")
	return "", false
end

local commands = {
	proxy_on = proxy_on,
	proxy_off = proxy_off,
	proxy_status = proxy_status,
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
		register_clink_lua_command("proxy_on")
		register_clink_lua_command("proxy_off")
		register_clink_lua_command("proxy_status")
	end
else
	print("proxy.lua requires a newer version of Clink; please upgrade.")
end
