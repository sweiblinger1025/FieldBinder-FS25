-- File: scripts/FieldBinder.lua
-- FieldBinder: Entry Point and integration for field logging functionality

-- Create the global FieldBinder object
FieldBinder = {}
_G["FieldBinder"] = FieldBinder

-- Load the logger logic from the core module
local modDirectory = g_currentModDirectory or ""
source(modDirectory .. "core/FieldBinderLogger.lua")

-- Callback: Executed when the mission (game) starts
function FieldBinder.onMissionStarted()
    if g_farmlandManager and g_farmlandManager.farmlands then
        -- Trigger the field size logging routine
        FieldBinderLogger.writeFieldSizes()
    else
        print("[FieldBinder] Farmland data not ready yet.")
    end
end

-- Hook into the game's mission start logic to call our function
Mission00.onStartMission = Utils.appendedFunction(Mission00.onStartMission, FieldBinder.onMissionStarted)

-- Register a console command to allow manual triggering
addConsoleCommand("fbWriteFieldSizes", "Writes field sizes to modSettings", "FieldBinderLogger.writeFieldSizes")

-- Confirmation output on mod load
print("[FieldBinder] Initialized basic field size writer from scripts/FieldBinder.lua")
