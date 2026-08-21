-- Initialize fnm for Clink/CMD with --use-on-cd (auto switch on cd).
-- Applies `fnm env --use-on-cd --shell cmd` (SET + doskey cd=...\cd.cmd).

if os.getenv("FNM_AUTORUN_GUARD") then
	return
end

local pipe = io.popen("fnm env --use-on-cd --shell cmd 2>nul")
if not pipe then
	return
end

local out = pipe:read("*a") or ""
pipe:close()
if out == "" then
	return
end

os.setenv("FNM_AUTORUN_GUARD", "AutorunGuard")

for line in out:gmatch("[^\r\n]+") do
	local name, value = line:match("^SET ([^=]+)=(.*)$")
	if name then
		os.setenv(name, value)
	else
		local alias_name, alias_def = line:match("^doskey ([^=]+)=(.*)$")
		if alias_name and alias_def and os.setalias then
			os.setalias(alias_name, alias_def)
		end
	end
end
