-- File: core/FieldBinderUtils.lua
-- Utility functions for FieldBinder

FieldBinderUtils = {}

--- Creates a folder if it doesn't exist
-- @param path string: Full path to the folder
function FieldBinderUtils.createFolderIfNotExists(path)
    if not fileExists(path) then
        createFolder(path)
    end
end
