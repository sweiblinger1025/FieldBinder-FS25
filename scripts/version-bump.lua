-- Usage: lua scripts/version-bump.lua 1.0.1
local newVersion = arg[1]
if not newVersion then
    print("❌ Please provide a version number, e.g., 1.0.1")
    os.exit(1)
end

local file = "./modDesc.xml"
local input = io.open(file, "r")
if not input then
    print("❌ Failed to open modDesc.xml. Are you in the correct folder?")
    os.exit(1)
end

local content = input:read("*all")
input:close()

local updated = content:gsub("<version>.-</version>", "<version>" .. newVersion .. "</version>")

local output = io.open(file, "w")
output:write(updated)
output:close()

print("🔁 modDesc.xml updated to version " .. newVersion)
