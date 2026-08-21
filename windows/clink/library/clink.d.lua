---@meta _
-- Clink Lua API stubs for lua_ls (not shipped by Clink upstream).
-- Docs: https://chrisant996.github.io/clink/clink.html

---Sets a process environment variable. Pass nil to unset.
---@param name string
---@param value string|nil
---@return boolean|nil
function os.setenv(name, value) end

---Creates or updates a doskey alias for the current console.
---@param name string
---@param command string
---@return boolean|nil
function os.setalias(name, command) end

---Returns the expansion text of a doskey alias, or nil.
---@param name string
---@return string|nil
function os.getalias(name) end

---Returns a list of doskey alias names.
---@return string[]
function os.getaliases() end

---Returns true if path is an existing directory.
---@param path string
---@return boolean
function os.isdir(path) end

---Returns true if path is an existing file.
---@param path string
---@return boolean
function os.isfile(path) end

---Returns files/dirs matching a glob pattern.
---@param pattern string
---@return table
function os.glob(pattern) end

---Creates a directory.
---@param path string
---@return boolean|nil
function os.mkdir(path) end

---@class clink
clink = {}

---Registers a callback that can rewrite or consume the input line before CMD runs it.
---Return a replacement string (and optional continue flag), or "", false to consume.
---@param func fun(line: string): string|nil, boolean|nil
function clink.onfilterinput(func) end

---Registers a callback invoked when Clink begins editing a new input line.
---@param func fun()
function clink.onbeginedit(func) end

---Parses a command line into command segments with line_state objects.
---@param line string
---@return table[]|nil
function clink.parseline(line) end

---Creates an argument matcher for a command.
---Having an argmatcher also colors the command with color.argmatcher.
---@param ... string
---@return table
function clink.argmatcher(...) end

---Creates a match generator. Lower priority runs earlier.
---@param priority? number
---@return table
function clink.generator(priority) end

---Directory match helper for argmatchers.
clink.dirmatches = clink.dirmatches

---@class settings
settings = {}

---@param name string
---@param default any
---@param short_desc string
---@param long_desc? string
function settings.add(name, default, short_desc, long_desc) end

---@param name string
---@return any
function settings.get(name) end

---@param name string
---@param value any
---@return boolean|nil
function settings.set(name, value) end
