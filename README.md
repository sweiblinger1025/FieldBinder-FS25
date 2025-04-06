# FieldBinder-FS25

**FieldBinder** is a modular data logger and operations tracker for Farming Simulator 25, starting with field size tracking and expanding into a full farming assistant toolkit.

## 🚜 Features
- Logs **owned field sizes** (in acres)
- Outputs files per map (e.g., `field_sizes_Riverbend.txt`)
- Saves to: `modSettings/FieldBinder/`
- Console command:  
  ```
  fbWriteFieldSizes
  ```

## 🗃 Example Output
```
FieldBinder - Owned Field Sizes
Map: MORiverBottom
============================
Field 13: 61.77 acres
Field 15: 171.03 acres
```

## 📦 Folder Structure
```
FieldBinder-FS25/
├── modDesc.xml
├── scripts/
│   └── FieldBinder.lua
├── README.md
├── LICENSE
└── .gitignore
```

## 🛠 Installation
1. Clone or download the repository.
2. Place it into your FS25 `mods/` folder.
3. Launch the game and load your save.
4. Open console and run:
   ```
   fbWriteFieldSizes
   ```

## 📌 Planned Modules
- Field checklists & planners
- Crop price logger
- Roleplay & event tracking
- Savegame-aware journals
