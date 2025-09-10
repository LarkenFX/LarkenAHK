; -- Global Variables --
global posX, posY, gameBoxX, gameBoxY, Title
global qxPos, qyPos

CoordMode, ToolTip, Client
CoordMode, Pixel, Client

^p::Pause, Toggle 	; Ctrl+P to pause
^q::qq()
+1::citizen()		; SHIFT+# to start script

; === Main Script ===
citizen(){
	startUp()
	setUpClient()
	ToolTip, Script started..., 0, 5, 1
	Sleep, 1000
	loop{
		ppCheck()
		relogCheck()
	}
}

; ----------------------------
; 		Action Functions
; ----------------------------
ppCheck(){
	waitTimer := 0
	; Wait for thieving icon (0xDFC376)
    while (true) {
		WinRestore, %Title%
		WinActivate, %Title%
		relogCheck()
		PixelSearch, posX, posY, %gameBoxX%, %gameBoxY%, 5, 30, 0xDFC376, 1, Fast RGB
		if (ErrorLevel == 0){
			break
		}
        Sleep, 300
    }
    foundPOS()  ; Click on citizen
    ; Check if gaining XP (0x7D00FF), wait max 3 seconds
    while (waitTimer < 11) {
		WinRestore, %Title%
		WinActivate, %Title%
        PixelSearch, posX, posY, %gameBoxX%, %gameBoxY%, 5, 30, 0x7D00FF, 1, Fast RGB
        if (ErrorLevel == 0)
            break
        Sleep, 300
        waitTimer++
    }
    if (waitTimer >= 11) {
        ToolTip, Click failed. Retrying..., 0, 5, 1
        return  ; Exit early, retry clicking citizen
    }
	
    ToolTip, Thieving..., 0, 5, 1
    Random, r, 32000, 47000
    Sleep, r
    ToolTip, Waiting for next %waitTimer%..., 0, 5, 1
	WinRestore, %Title%
	WinActivate, %Title%
    Click, %qxPos%, %qyPos%
}
relog(){
	Sleep, 1000
	imagePath := A_ScriptDir . "\playNowV3.png"
	ImageSearch, posX, posY, 5, 30, %gameBoxX%, %gameBoxY%, *50 %imagePath%
	if (ErrorLevel == 0){
		ToolTip, Delaying relog..., 0, 5, 1
		Random, r, 6000,10000
		Sleep, r
		foundPOS()
		waitForColor(0x3F0200)
		foundPOS()
	}
}
; ----------------------------
; 		Utility Functions
; ----------------------------
qq(){
	MouseGetPos, qxPos, qyPos
}
foundPOS(){
	modY := posY + 15
	Click, %posX%, %modY%
}
relogCheck(){
	imagePath := A_ScriptDir . "\6hrOKV3.png"
	ImageSearch, posX, posY, 5, 30, %gameBoxX%, %gameBoxY%, *50 %imagePath%
	if (ErrorLevel == 0){
		ToolTip,Relog Initiated..., 0, 5, 1
		foundPOS()
		relog()
	}
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
; ----------------------------
; 		Setup Functions
; ----------------------------
setUpClient(){
	SysGet, res, MonitorWorkArea
	Title = RuneLite
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
	LarkenAHK's Wealthy Citizen Script.`n
	-Use the provided RuneLite profile.
	-Set ATK options to hidden.
	-Set normal citizens/dog left-click -> walk-here
	-Set CTRL+Q hotkey to the coin pouch spot.
	-Have the XP tracker sidebar open before start.
	
	Press OK if setup is correct & script will start. 
	Press Cancel to make changes then use Shift+1 to restart.
	)
	ifMsgBox Cancel
	{
		Reload
	}
}