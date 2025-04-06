# 📦 FieldBinder Changelog

All notable changes to this project will be documented here. This file uses [Keep a Changelog](https://keepachangelog.com/) principles.

---

## [1.0.0.12] – 2025-04-06
### Added
- CSV export alongside TXT export for field data.
- Field state tracking: crop, growth, fertilizer, plowed, limed, weeds.
- Advanced field status: roller, stones, stubble shred, mulched, tillage state.
- Console command `fbWriteFieldSizes` to manually trigger data export.
- Automatic file naming based on map name (e.g., `field_sizes_MORiverBottom.csv`).
- Logger fully modularized into `FieldBinderLogger.lua`.
- Utility module `FieldBinderUtils.lua` created for shared helpers.
- FieldBinder main script (`FieldBinder.lua`) documented and modular.

### Changed
- Function `createFolderIfNotExists()` moved to `FieldBinderUtils.lua`.
- Logger moved from monolithic script to dedicated core/ folder structure.
- `modDesc.xml` updated to include all modules with in-line comments.

### Fixed
- Missing fruit type fallback for unknown crops.
- Fertilizer type and level properly detected and displayed.
- Field ownership correctly validated for all field types.

---

## [Unreleased]
### Planned
- Add moisture tracking to field state output.
- Support for partial field ownership and contracts.
- Integration with future checklist/planner system.
- Customizable output formatting (UI toggle or config file).

---

