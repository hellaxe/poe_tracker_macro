# Poe Tracker Macro
Mods Tracker AHK script for Race Events in Path of Exile. You need this **only** if you want to help with mods reporting. If you want to check mods - go to the site http://poetracker.com and enjoy.

## Installation
Installation of this script requires to install AutoHotkey software.
Here is the short to-do list:
  - [Download](https://autohotkey.com/) and install AutoHotkey. Don't install AutoHotkey v2.x.
  - [Download](https://github.com/hellaxe/poe_tracker_macro/archive/master.zip) poe_tracker script from the github repo as `*.zip` file
  - Extract this file to separate folder
  - Make sure to run PoE in (borderless) windowed mode.
  - Run `poe_tracker.ahk`

For the first time you will need to provide settings to the script such as POE folder path and hotkey combination. After this setup you are ready to go!
Regarding POE folder, this folder script needs to read the chat logs to parse current location. Usually this file placed at `/logs/Client.txt` in the POE directory, but i am not 100% sure. If you use steam version, find your POE folder in `steamapps/common`.

## Usage

In-game when you are entering any zone, just look at the zone mods, hit the hotkey and select button corresponding to this mod. That's it, you're awesome! Thank you!

## Troubleshooting
This is very first version of the script, so issues are very possible. Please, let me know if there any errors. You can use [feedback form](http://poetracker.com/feedbacks/new) or github repo to report the issue.

**Q: It does not works with Russian/Spanish/~~Elven~~ POE Client**

A: Yep, this is alpha version, but in the future i want to add support of all languages.

**Q: I have an error "Memory limit reached"**

A: It means that the file Client.txt in `%POE_FOLDER%/logs/` is very large. Best solution is to remove this file if you dont need the history of your chat logs. Or you can open the script (poe_tracker.ahk) in the editor and change the first line from `#MaxMem 256` to `#MaxMem 512` but in the future the problem may repeat. Looks like Path of Exile does not have logs rotation.

## Happy Mapping, Exile!
