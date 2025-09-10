; -- Global Variables --
global posX, posY, gameBoxX, gameBoxY, Title, Client1, Client2
global qxPos, qyPos, imagePath

SetWorkingDir %A_ScriptDir%
CoordMode, ToolTip, Client
CoordMode, Pixel, Client
CoordMode, Mouse, Client

^p::Pause, Toggle 	; Ctrl+P to pause
^q::savePosQ()
+1::crabFight()		; SHIFT+# to start script

;		=== Setup ===
;

;		=== Main Script ===
crabFight(){
	startUp()
	setUpClient()
	SetTitleMatchMode, 1
	Client1 := "RuneLite - humble larky"
	Client2 := "RuneLite - Old Larken"
	multiboxSetup()
	sleep, 1000
	loop{
		relogCheck()
		waitForColor(0xFF00FF)
		waitForColor(0x0000FF)
		foundPOS()
		while(colorExists(0xFF00FF)){
			ToolTip, Fighting Crab..., 0, 5, 1
			Sleep, 30000
			relogCheck()
		}
		ToolTip, Crab is dead..., 0, 5, 1
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
relog(){
	Sleep, 1000
	imagePath := A_ScriptDir . "\images\playNowV3.png"
	ImageSearch, posX, posY, 5, 30, %gameBoxX%, %gameBoxY%, *50 %imagePath%
	if (ErrorLevel == 0){
		Random, r, 600000,1000000
		Sleep, r
		foundPOS()
		waitForColor(0x73433E)
		foundPOS()
		waitForColor(0x00FFDD)
		foundPOS()
	}
}
; 		=== Utility Functions ===
savePosQ(){
	MouseGetPos, qxPos, qyPos
}
foundPOS(){
	modY := posY + 15
	WinRestore, %Client1%
	WinActivate, %Client1%
	Click, %posX%, %modY%
	Sleep, 100
	WinRestore, %Client2%
	WinActivate, %Client2%
	Sleep, 500
	Click, %posX%, %modY%
}
colorExists(hexCode){
	WinRestore, %Client1%
	WinActivate, %Client1%
	PixelSearch, posX, posY, 5, 30, %gameBoxX%, %gameBoxY%, %hexCode%, 1, Fast RGB
	return (ErrorLevel == 0)
}
waitForColor(hexCode){
	loop {
		WinRestore, %Client1%
		WinActivate, %Client1%
		PixelSearch, posX, posY, 5, 30, %gameBoxX%, %gameBoxY%, %hexCode%, 1, Fast RGB
		if (ErrorLevel == 0)
			break
		Sleep, 500
	}
}
relogCheck(){
	imagePath := A_ScriptDir . "\images\6hrOKV3.png"
	ImageSearch, posX, posY, 5, 30, %gameBoxX%, %gameBoxY%, *50 %imagePath%
	if (ErrorLevel == 0){
		foundPOS()
		relog()
	}
}
radialSearch(hexCode){
	midX := 645
	midY := 415
	loop 16{
		radiusX1 := midX - 25 * A_Index
		radiusY1 := midY - 25 * A_Index
		radiusX2 := midX + 25 * A_Index
		radiusY2 := midY + 25 * A_Index
		; search starting at player radially to edge of search box bottom to top
		PixelSearch, posX, posY, radiusX2, radiusY2, radiusX1, radiusY1, %hexCode%, 1, Fast RGB
		if (ErrorLevel == 0){
			break
		}
	}
}
checkInvFull(){
	bagX1 := gameBoxX + 175
	bagY1 := gameBoxY - 45
	bagX2 := gameBoxX + 210
	bagY2 := gameBoxY - 15
}
checkAllInv(){
	bagX1 := gameBoxX + 50
	bagY1 := gameBoxY - 260
	bagX2 := gameBoxX + 210
	bagY2 := gameBoxY - 15
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
multiboxSetup(){
	clientLocX := 25
	clientLocY := 25
	; Move Client1
	if WinExist(Client1) {
		WinRestore
		WinMove, , , %clientLocX%, %clientLocY%  ; ← no width or height = no resize
	} else {
		MsgBox, 16, Error, Could not find window: %Client1%
	}

	; Move Client2 to the exact same position
	if WinExist(Client2) {
		WinRestore
		WinMove, , , %clientLocX%, %clientLocY%
	} else {
		MsgBox, 16, Error, Could not find window: %Client2%
	}
}
startUp(){
	MsgBox, 1, LarkenAHK,
	(
	LarkenAHK's GemCrab Script.
	
	-Use the provided RuneLite profile.
	-Mark crab 0xFF00FF (pink) & all tunnels 0x00FFDD (cyan).
	-No hotkeys are needed. 
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