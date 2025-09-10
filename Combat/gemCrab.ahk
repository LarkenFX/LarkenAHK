; -- Global Variables --
global posX, posY, gameBoxX, gameBoxY, Title
global qxPos, qyPos

SetWorkingDir %A_ScriptDir%
CoordMode, ToolTip, Client
CoordMode, Pixel, Client
CoordMode, Mouse, Client

^p::Pause, Toggle 	; Ctrl+P to pause
^q::savePosQ()
+1::crabFight()		; SHIFT+# to start script

;		=== Setup ===
;	-Mark crab 0xFF00FF (pink) & all tunnels 0x00FFDD (cyan).
;	-Ctrl+Q on Dragon Battleaxe if needed. 
;	-Have the XP tracker sidebar open before start.

;		=== Main Script ===
crabFight(){
	startUp()
	setUpClient()
	sleep, 1000
	loop{
		waitForColor(0xFF00FF)
		waitForColor(0x0000FF)
		foundPOS()
		while(colorExists(0xFF00FF)){
			ToolTip, Fighting Crab..., 0, 5, 1
			Sleep, 30000
		}
		ToolTip, Crab is dead..., 0, 5, 1
		;=== if using Dragon Battleaxe specs ===
		if (qxPos > 0){
			Click, %qxPos%, %qyPos%
			delay()
			imagePath := A_ScriptDir . "\images\specOrb.png"
			ImageSearch, cx, cy, 1110, 158, 1155, 208, *20 %imagePath%
			if (ErrorLevel == 0){
				Click, %cx%, %cy%
			}
			delay()
			Click, %qxPos%, %qyPos%
			delay()
		}
		waitForColor(0x00FFDD)
		foundPOS()
		sleep, 3000
	}
}


; 		=== Action Functions ===

; 		=== Utility Functions ===
savePosQ(){
	MouseGetPos, qxPos, qyPos
}
foundPOS(){
	modY := posY + 15
	Click, %posX%, %modY%
}
colorExists(hexCode){
	WinRestore, %Title%
	WinActivate, %Title%
	PixelSearch, posX, posY, 5, 30, %gameBoxX%, %gameBoxY%, %hexCode%, 1, Fast RGB
	return (ErrorLevel == 0)
}
waitForColor(hexCode){
	loop {
		WinRestore, %Title%
		WinActivate, %Title%
		PixelSearch, posX, posY, 5, 30, %gameBoxX%, %gameBoxY%, %hexCode%, 1, Fast RGB
		if (ErrorLevel == 0)
			break
		Sleep, 500
	}
}
delay(min := 240, max := 440){
    Random, delay, %min%, %max%
    Sleep, delay
}
; 		=== Setup Functions ===
setUpClient(){
	SysGet, res, MonitorWorkArea
	SetTitleMatchMode, 2
	Title := "RuneLite"
	GetClientSize(WinExist(Title), wcW, wcH)
	gameBoxX := wcW - 526
	gameBoxY := wcH - 32
}
GetClientSize(hWnd, ByRef w := "", ByRef h := ""){
	VarSetCapacity(rect, 16)
	DllCall("GetClientRect", "ptr", hWnd, "ptr", &rect)
	w := NumGet(rect, 8, "int")
	h := NumGet(rect, 12, "int")
}
startUp(){
	MsgBox, 1, LarkenAHK,
	(
	LarkenAHK's GemCrab Script.
	
	-Use the provided RuneLite profile.
	-Mark crab 0xFF00FF (pink) & all tunnels 0x00FFDD (cyan).
	-Ctrl+Q on Dragon Battleaxe if using.
	-Have the XP tracker sidebar open before start.
	-Crab must be on screen currently before start.
	
	Press OK if settings are correct & script will start. 
	Press Cancel to make changes & use Shift+1 afterward.
	)
	ifMsgBox Cancel
	{
		Reload
	}
}