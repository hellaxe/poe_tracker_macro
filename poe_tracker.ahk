#Include vendor\JSON.ahk
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
current_version := "0.2.1"
poe_folder := ""
report_hotkey := ""
poe_tracker_url := "http://poetracker.com"
Menu,tray, add, Settings,open_settings

LastLines(varFilename,varLines=1) {
	linecount:=0
	file:=FileOpen(varFilename, "r")
	if (not file)
		return 0
	Loop {
		file.Seek(0-A_Index, 2)
		line:=file.Read(1)
		if ((RegExMatch(line,"`n") or RegExMatch(line,"`r")) and not File.AtEOF)
			linecount++
	} until ((RegExMatch(line,"`n") or RegExMatch(line,"`r")) and not File.AtEOF and linecount=varLines)
	Loop {
		output.=file.Readline()
	} until (File.AtEOF)
	file.Close()
	return output
}

PT_Check_Version() {
	global current_version, poe_tracker_url
	url := poe_tracker_url . "/versions.json"
	WinHTTP := ComObjCreate("WinHTTP.WinHttpRequest.5.1")

	WinHTTP.Open("GET", url, 0)
	WinHTTP.Send()
	parsed_json := JSON.Load(WinHTTP.responseText)
	latest_version := parsed_json.versions.ahk

	latest := 1

	if not RegExMatch(current_version, "^" latest_version "$")
		MsgBox, Your version is %current_version%, while latest version is %latest_version%. Please Update.
	return
}

PT_LoadSettings() {
	global poe_folder, report_hotkey
	IniRead, poe_folder, %A_ScriptDir%\settings.ini, general, poe_folder
	IniRead, report_hotkey, %A_ScriptDir%\settings.ini, general, report_hotkey
	
	if StrLen(poe_folder) > 0 and StrLen(report_hotkey) > 0
		return True
	else
		return False
}

PT_Check_Version()
if PT_LoadSettings() {
	global report_hotkey
	Hotkey, %report_hotkey%,report, On
	return
}
else {
	GoTo open_settings
}

PT_Get_Location(){ 
	global t
	if not FileExist(poe_folder . "\logs\Client.txt")
		PT_Show_Tooltip("Unable to read chat logs. Make sure you have right poe path in settings.")

	l := LastLines(poe_folder . "\logs\Client.txt", 100)

	Loop, Parse, l, `n
	{
		if RegExMatch(A_LoopField, "You have entered (.*)\.") {
			RegExMatch(A_LoopField, "You have entered (.*)\.", sub_pattern)
		}
	  		
	}
	
	return sub_pattern1
}

PT_Is_Valid_Location(location) {
  if (StrLen(location) = 0) {
    return False
  }
	if (RegExMatch(location, "i)hideout|lioneye's watch|the forest encampment|the sarn encampment|highgate|overseer's tower|the bridge encampment|oriath docks|^oriath$")) {
		return False
	}

	return True
}

PT_Draw_GUI(current_location) {
	Gui,Font, s12, Arial
	Gui, Add, Text,x5 y5,Your zone: %current_location%
	Gui, Add, Button,x5 y35 h30 w110 gbreach,Breach
	; Gui, Add, Button,x125 y35 h30 w110 gperandus,Perandus
	Gui, Add, Button,x125 y35 h30 w110 gexiles,Exiles
	Gui, Add, Button,x245 y35 h30 w110 ginvaders,Invaders

	Gui, Add, Button,x65 y70 h30 w110 gstrongboxes,Strongboxes
	Gui, Add, Button,x185 y70 h30 w110 gspirits,Spirits
	; Gui, Add, Button,x125 y70 h30 w110 gnemesis,Nemesis
	; Gui, Add, Button,x245 y70 h30 w110 gbloodlines,Bloodlines

	
	
	; Gui, Add, Button,x245 y105 h30 w110 gbeyond,Beyond
	Gui, Show,, Select mod on the location
	return
}

PT_Is_Ambiguous_Location(location) {

}

PT_Show_Tooltip(text) {
	Global X, Y
	
	; Get position of mouse cursor
	MouseGetPos, X, Y
	WinGet, PoEWindowHwnd, ID, ahk_group PoEWindowGrp
	RelativeToActiveWindow := true	; default tooltip behaviour 	

	ScreenOffsetY := A_ScreenHeight / 2
	ScreenOffsetX := A_ScreenWidth / 2
	
	XCoord := 0 + ScreenOffsetX
	YCoord := 0 + ScreenOffsetY

		
	Fonts.SetFixedFont()
	ToolTip, %text%, XCoord, YCoord

	

	ToolTipTimeout := 0
	SetTimer, ToolTipTimer, 100
}

PT_Send_Results(location, mod) {
	global poe_tracker_url
	url := poe_tracker_url . "/reports"
	WinHTTP := ComObjCreate("WinHTTP.WinHttpRequest.5.1")

	WinHTTP.Open("POST", url, 0)
	WinHTTP.SetRequestHeader("Content-Type", "application/json")
	Body := "{""location"": """ . location . """, ""mod"": """ . mod . """}"
	WinHTTP.Send(Body)
	return
}

report:
	current_location := PT_Get_Location()
	if PT_Is_Valid_Location(current_location) {
		PT_Draw_GUI(current_location)	
	} else {
		PT_Show_Tooltip(current_location . " is not a valid location.")
	}
		
	
	return
	
breach:
	PT_Send_Results(current_location, "breaches")
	Gui Destroy
	return

spirits:
	PT_Send_Results(current_location, "spirits")
	Gui Destroy
	return

exiles:
	PT_Send_Results(current_location, "exiles")
	Gui Destroy
	return

perandus:
	PT_Send_Results(current_location, "perandus")
	Gui Destroy
	return

invaders:
	PT_Send_Results(current_location, "invaders")
	Gui Destroy
	return

strongboxes:
	PT_Send_Results(current_location, "boxes")
	Gui Destroy
	return

nemesis:
	PT_Send_Results(current_location, "nemesis")
	Gui Destroy
	return

bloodlines:
	PT_Send_Results(current_location, "bloodlines")
	Gui Destroy
	return

beyond:
	PT_Send_Results(current_location, "beyond")
	Gui Destroy
	return


GuiClose:
GuiEscape:
	Gui Destroy
	return

open_settings:
	global report_hotkey, poe_folder

	Gui,Font, s10, Arial
	Gui, Add, Text,,Path to the Path of Exile
	Gui, Add, Edit, vFolder
	Gui, Add, Button, gbrowse,Browse
	Gui, Add, Text,, Hotkey for report
	Gui, Add, Hotkey, vHK gLabel
	Gui, Add, Button, gsave,Save
	Gui, Show,, Settings

	GuiControl,, Folder, %poe_folder%
	GuiControl,, HK, %report_hotkey%
	Folder := poe_folder
	HK := report_hotkey
	
	return	

label: 
	global report_hotkey
	If HK in +,^,!,+^,+!,^!,+^!
	  return
	 If (report_hotkey) {
	  Hotkey, %report_hotkey%,report, Off
	  report_hotkey .= " OFF"
	 }
	 If (HK = "") {
	  report_hotkey =                             ;     save the hotkey (which is now blank) for future reference.
	  return
	 }
	 Gui, Submit, NoHide
	 
	 If StrLen(HK) = 1
	  HK := "~" HK
	 Hotkey, %HK%,report, On
	 report_hotkey := HK
	return
	
browse:
	FileSelectFolder, Folder
	GuiControl,, Folder, %Folder%
	; Folder := RegExReplace(Folder, "\\$")
	; FolderPath := Folder
	return

save:
	IniWrite, %HK%, %A_ScriptDir%\settings.ini, general, report_hotkey
	IniWrite, %Folder%, %A_ScriptDir%\settings.ini, general, poe_folder
	poe_folder := Folder
	Gui Destroy
	return

ToolTipTimer:
	MouseGetPos, CurrX, CurrY
	MouseMoved := (CurrX - X) ** 2 + (CurrY - Y) ** 2 > 25 ** 2
	If (MouseMoved)
	{
		ToolTip
	}
	return
