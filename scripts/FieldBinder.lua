-- File: scripts/FieldBinder.lua
-- FieldBinder: Field Size Logger (Phase 1 - Basic TXT Writer)
-- This script creates a folder in modSettings/ and writes a text file with owned field sizes

FieldBinder = {}

local modDirectory = g_currentModDirectory or "" -- support for local testing
local modSettingsPath = getUserProfileAppPath() .. "modSettings/FieldBinder/"

function FieldBinder.writeFieldSizes()
    createFolderIfNotExists(modSettingsPath)

    local mapName = g_currentMission.missionInfo.map.title or "UnknownMap"
    mapName = mapName:gsub("%s+", ""):gsub("[^%w_]", "") -- sanitize to filename-safe format
    local fieldSizeFile = modSettingsPath .. "field_sizes_" .. mapName .. ".txt"

    local file = io.open(fieldSizeFile, "w")
    if file == nil then
        print("[FieldBinder] Error: Could not write to file: " .. fieldSizeFile)
        return
    end

    file:write("FieldBinder - Owned Field Sizes\n")
    file:write("Map: " .. mapName .. "\n")
    file:write("============================\n")

    for fieldIndex, field in pairs(g_fieldManager.fields) do
        if field.farmland and field.farmland.isOwned then
            local fieldId = field.name or tostring(fieldIndex)
            local areaHa = field.areaHa or 0
            local areaAcres = areaHa * 2.47105
            file:write(string.format("Field %s: %.2f acres\n", fieldId, areaAcres))
        end
    end

    file:close()
    print("[FieldBinder] Field sizes saved to " .. fieldSizeFile)
end

function createFolderIfNotExists(path)
    if not fileExists(path) then
        createFolder(path)
    end
end

-- Optional: Hook into a key or console command for testing
addConsoleCommand("fbWriteFieldSizes", "Writes field sizes to modSettings", "writeFieldSizes", FieldBinder)

-- Debug note
print("[FieldBinder] Initialized basic field size writer from scripts/FieldBinder.lua")
