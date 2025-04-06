-- File: core/FieldBinderLogger.lua
-- Purpose: Logs field ownership, area, crop data, and field state conditions to TXT and CSV formats.

FieldBinderLogger = {}

-- Import utility module
source(g_currentModDirectory .. "core/FieldBinderUtils.lua")

--- Writes owned field data to TXT and CSV files in modSettings/FieldBinder.
-- @function FieldBinderLogger.writeFieldSizes
-- @desc Collects data for all owned fields and logs size, crop type, and field condition layers (e.g., fertilized, plowed, weeds).
-- @usage Called at mission start or via console command "fbWriteFieldSizes"
-- @return nil
function FieldBinderLogger.writeFieldSizes()
    -- Setup modSettings output path and filename based on map name
    local modSettingsPath = getUserProfileAppPath() .. "modSettings/FieldBinder/"
    FieldBinderUtils.createFolderIfNotExists(modSettingsPath)

    local mapName = g_currentMission.missionInfo.map.title or "UnknownMap"
    mapName = mapName:gsub("%s+", ""):gsub("[^%w_]+", "")
    local fieldSizeFile = modSettingsPath .. "field_sizes_" .. mapName .. ".txt"
    local fieldCsvFile = modSettingsPath .. "field_sizes_" .. mapName .. ".csv"

    -- Open file handles
    local file = io.open(fieldSizeFile, "w")
    local csv = io.open(fieldCsvFile, "w")
    if file == nil or csv == nil then
        print("[FieldBinder] Error: Could not open one or both output files.")
        return
    end

    -- Write headers to TXT and CSV
    file:write("FieldBinder - Owned Field Sizes\n")
    file:write("Map: " .. mapName .. "\n")
    file:write("====================================================================================================================================================================\n")
    file:write("Field Index | Field ID        | Hectares | Acres   | Crop     | Growth | Fertilized     | Plowed | Limed | Weeds       | Roller | Stones | Stubble | Mulched | Tillage\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    csv:write("FieldIndex,FieldID,Hectares,Acres,Crop,Growth,FertType,FertLevel,Plowed,Limed,Weeds,Roller,Stones,StubbleShred,Mulched,TillageState\n")

    -- Loop through all fields on the map
    -- g_fieldManager.fields is a table where each key is the numeric field index and each value is a field object.
    -- Each field object typically contains attributes like name, areaHa (hectares), fieldState (a structure with growth, crop, spray, tillage status), and farmland reference.
    for fieldIndex, field in pairs(g_fieldManager.fields) do
        if field.farmland and field.farmland.isOwned then
            -- Basic metadata
            local fieldId = field.name or tostring(fieldIndex)
            local areaHa = field.areaHa or 0
            local areaAcres = areaHa * 2.47105

            -- Default values for field status
            local cropType = "None"
            local growthState = "-"
            local fertilized = "No"
            local plowed = "No"
            local limed = "No"
            local weeds = "No"
            local fert_type = "None"
            local fert_level = 0
            local roller = "No"
            local stones = "0"
            local stubble = "No"
            local mulched = "No"
            local tillage = "-"

            -- Get crop info if fruit type is set
            local fruitIndex = field.fieldState and field.fieldState.fruitTypeIndex
            if fruitIndex and fruitIndex > 0 then
                local fruit = g_fruitTypeManager:getFruitTypeByIndex(fruitIndex)
                if fruit then
                    cropType = string.upper(fruit.name)
                end
                local growth = tonumber(field.fieldState.growthState or 0)
                growthState = string.format("%d", growth)
            end

            -- Fertilizer logic
            local sprayLevel = tonumber(field.fieldState and field.fieldState.sprayLevel or 0)
            local sprayType = tonumber(field.fieldState and field.fieldState.sprayType or 0)

            if sprayType == 1 then fert_type = "Dry"
            elseif sprayType == 2 then fert_type = "Liquid"
            elseif sprayType == 3 then fert_type = "Manure"
            elseif sprayType == 4 then fert_type = "Slurry" end

            if sprayLevel > 0 and (sprayType >= 1 and sprayType <= 4) then
                fertilized = string.format("Yes (%d, %s)", sprayLevel, fert_type)
                fert_level = sprayLevel
            end

            -- Other field states
            plowed = field.fieldState and field.fieldState.needsPlowing and "Yes" or "No"
            limed = field.fieldState and field.fieldState.needsLime and "Yes" or "No"
            local weedLevel = tonumber(field.fieldState and field.fieldState.weedState or 0)
            weeds = weedLevel > 0 and string.format("Yes (%d)", weedLevel) or "No"

            roller = (field.fieldState.rollerLevel or 0) > 0 and "Yes" or "No"
            stones = tostring(field.fieldState.stoneLevel or 0)
            stubble = (field.fieldState.stubbleShredLevel or 0) > 0 and "Yes" or "No"
            mulched = (field.fieldState.mulchLevel or 0) > 0 and "Yes" or "No"
            tillage = tostring(field.fieldState.tillageState or "-")

            -- Output formatted data line to both TXT and CSV
            local txtLine = string.format("%-12s %-15s %-9.2f %-8.2f %-9s %-8s %-15s %-7s %-6s %-11s %-7s %-7s %-8s %-8s %-8s\n",
                tostring(fieldIndex), fieldId, areaHa, areaAcres, cropType, growthState, fertilized, plowed, limed, weeds, roller, stones, stubble, mulched, tillage)
            local csvLine = string.format("%s,%s,%.2f,%.2f,%s,%s,%s,%d,%s,%s,%s,%s,%s,%s,%s,%s\n",
                tostring(fieldIndex), fieldId, areaHa, areaAcres, cropType, growthState, fert_type, fert_level, plowed, limed, weeds, roller, stones, stubble, mulched, tillage)

            file:write(txtLine)
            csv:write(csvLine)

            -- Debug print toggle (set this to true to enable console logging)
            local debugMode = false
            if debugMode then
                print("[FieldBinder] CSV line:", csvLine)
            end
        end
    end

    -- Close files and finish
    file:close()
    csv:close()
    print("[FieldBinder] Field sizes saved to " .. fieldSizeFile)
    print("[FieldBinder] Field sizes (CSV) saved to " .. fieldCsvFile)
end
