#Requires AutoHotkey v1.1

; -- Global Variables --
global posX, posY, gameBoxX, gameBoxY, Title, modX, modY
global isFishing, invFull
global qxPos, qyPos

SendMode, Input
CoordMode, ToolTip, Client
CoordMode, Pixel, Client
CoordMode, Mouse, Client

^p::Pause, Toggle 	; Ctrl+P to pause
^q::savePosQ()
+1::test()		; SHIFT+# to start script
^!c:: ; Ctrl+Alt+C to capture mouse coords 1074 - 1116 x 568 - 604
MouseGetPos, mx, my
MsgBox, Mouse at: %mx%, %my%
return

;		=== Main Script ===
test(){
	;startUp()
	setUpClient()
	sleep, 1000
	loop{
		ToolTip, TESTING..., 0, 5, 1
		fishingCheck()
		checkInvFull(0xFF0000)
		delay()
		if(isFishing == 0 && invFull == 0){
			delay()
			radialSearch(0xFF00FF)
			foundPOS()
			delay(4000,6000)
		}
		if(invFull == 1){
			delay()
			dropAll()
			invFull := 0
		}
	}
}


; 		=== Action Functions ===
fishingCheck(){
    focusClient()
    PixelSearch, posX, posY, 10, 50, 135, 70, 0x00FF00, 1, Fast RGB
    isFishing := (ErrorLevel == 0) ? 1 : 0
}
dropAll() {
    ; Inventory position and slot size
    startX := 1074
    startY := 568
    slotW := 42
    slotH := 36
    cols := 4
    rows := 7
    ; Slight row shuffle (example: 0 2 1 3 5 4 6)
    rowOrder := shuffleRows()
    focusClient()
    for i, row in rowOrder {
        Loop, %cols% {
            col := A_Index - 1
            x := startX + col * slotW + slotW // 2
            y := startY + row * slotH + slotH // 2
            ; Detect red item in slot
            PixelSearch, px, py, x - 6, y - 6, x + 6, y + 6, 0xFF0000, 5, Fast RGB
            if (ErrorLevel == 0) {
                MouseMoveL(px + 5, py + 5, 10, 2)
                Click
                Sleep, 110  ; mimic human timing
            }
        }
    }
}
; 		=== Utility Functions ===
savePosQ(){
	MouseGetPos, qxPos, qyPos
}
foundPOS(){
    modX := posX + 5
	modY := posY + 10
    focusClient()
    MouseMoveL(modX, modY, 10, 2)
	Click,
}
waitForColor(hexCode){
	loop {
		focusClient()
		PixelSearch, posX, posY, 5, 30, %gameBoxX%, %gameBoxY%, %hexCode%, 1, Fast RGB
		if (ErrorLevel == 0)
			break
		Sleep, 500
	}
}
colorExists(hexCode){
    focusClient()
	PixelSearch, posX, posY, 5, 30, %gameBoxX%, %gameBoxY%, %hexCode%, 1, Fast RGB
	return (ErrorLevel == 0)
}
colorExistsInv(hexCode){
    bagX1 := gameBoxX + 50
	bagY1 := gameBoxY - 260
	bagX2 := gameBoxX + 210
	bagY2 := gameBoxY - 15
    focusClient()
	PixelSearch, posX, posY, %bagX1%, %bagY1%, %bagX2%, %bagY2%, %hexCode%, 1, Fast RGB
	return (ErrorLevel == 0)
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
		PixelSearch, posX, posY, radiusX1, radiusY1, radiusX2, radiusY2, %hexCode%, 1, Fast RGB
		if (ErrorLevel == 0){
			break
		}
	}
}
checkInvFull(hexCode){
	bagX1 := gameBoxX + 175
	bagY1 := gameBoxY - 45
	bagX2 := gameBoxX + 210
	bagY2 := gameBoxY - 15
    focusClient()
	PixelSearch, PosX, PosY, %bagX1%, %bagY1%, %bagX2%, %bagY2%, %hexCode%, 1, Fast RGB
	invFull := (ErrorLevel == 0) ? 1 : 0
}
checkAllInv(){
	bagX1 := gameBoxX + 50
	bagY1 := gameBoxY - 260
	bagX2 := gameBoxX + 210
	bagY2 := gameBoxY - 15
}
MouseMoveL(x2, y2, steps := 15, sleepTime := 3) {
    MouseGetPos, x1, y1
    dx := x2 - x1
    dy := y2 - y1

    Loop, %steps% {
        i := A_Index
        progress := (1 - Cos(3.14159 * i / steps)) / 2  ; Ease-in-out (sine)

        x := x1 + (dx * progress)
        y := y1 + (dy * progress)

        MouseMove, %x%, %y%, 0
        Sleep, sleepTime
    }
}
focusClient(){
	WinRestore, %Title%
	WinActivate, %Title%
}
delay(min := 240, max := 440){
    Random, delay, %min%, %max%
    Sleep, delay
}
shuffleRows() {
    base := [0, 1, 2, 3, 4, 5, 6]
    Random, swaps, 1, 3  ; how many small swaps to make
    Loop, %swaps% {
        Random, i, 0, 5  ; pick a position
        j := i + 1
        ; Swap i and i+1
        temp := base[i + 1]
        base[i + 1] := base[j + 1]
        base[j + 1] := temp
    }
    return base
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
	LarkenAHK's TEMPLATE Script.
	
	-Use the provided RuneLite profile.
	-No hotkeys are needed. 
	-Have the XP tracker sidebar open before start.
	
	Press OK if settings are correct & script will start. 
	Press Cancel to make changes & use Shift+1 afterward.
	)
	ifMsgBox Cancel
	{
		Reload
	}
}