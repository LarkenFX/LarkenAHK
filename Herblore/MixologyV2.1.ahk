; -- Global Variables --
global posX, posY, gameBoxX, gameBoxY, Title
global logFile := A_ScriptDir . "\potion_log.txt"

SendMode, Input
SetWorkingDir %A_ScriptDir%
CoordMode, Pixel, Client
CoordMode, Mouse, Client
CoordMode, ToolTip, Client

^p::Pause, Toggle 	; Ctrl+P to pause
Tab::test()		; SHIFT+# to start script

;		=== Main Script ===
test(){
	setUpClient()
	sleep, 1000
    deposit := 0
    ; === Fixed potion positions ===
    potionSlots := [ {x:8, y:75}, {x:8, y:100}, {x:8, y:125} ]

    ; === Possible Potions ===
    colors := ["LLL", "AAA", "MMM", "MMA", "MML", "AAM"]
    colorMap := {L: 0xFF0000, A: 0x00FF00, M: 0x0000FF}
    loop{
        potionColors := []
        potCount := 0
        ; Detect colors for all potion slots first
        for index, slot in potionSlots {
            detectedColor := ""
            for _, clr in colors {
                imagePath := A_ScriptDir . "\images\" . clr . ".png"
                if !FileExist(imagePath) {
                    log("Missing color image: " . imagePath)
                    continue
                }
                ImageSearch, cx, cy, slot.x, slot.y, slot.x+190, slot.y+35, *20 %imagePath%
                if (ErrorLevel = 0) {
                    detectedColor := clr
                    break
                }
            }
            if (detectedColor = "") {
                log("Failed to detect COLOR for potion #" . index . )
                MsgBox, Failed to detect potion #%index%. Script aborted.
                ExitApp
            }
            potionColors.push(detectedColor)
        }
        ; Determine if all use Mox
        allMox := true
        for _, color in potionColors {
            if !InStr("MMM,MML,MMA", color) {
                allMox := false
                break
            }
        }
        ;log("Only Mox pots - " . allMox)
        ; Process potions, skipping Mox unless all use Mox then just do 1 pot
        for index, color in potionColors {
            if (InStr("MMM,MML,MMA", color) && !allMox) {
                ;log("Potion #" . index . " is a Mox")
                continue
            }
            if (allMox && index > 1){
                continue
            }

        ToolTip, Mixing Potion %index% (%color%)..., 0, 0, 1
        ; Pull levers to mix potions according to its name
        for i, letter in StrSplit(color) {
            hexColor := colorMap[letter]
            waitForColor(hexColor)
            foundPOS()
            if (i < 2){ ; first level pull delay to return to levers
                delay(2000,2200)
            }else{
                delay()
            }
        }
            ; grab potion from flask
            waitForColor(0x7D00FF)
            foundPOS()
            Sleep, 2000
            potCount++
        }
            ; === Use stations, try for speed ups ===
        loop %potCount%{
            ToolTip, Using station for potion %A_Index%..., 0, 0, 1
            waitForColor(0xFF00FF)
            foundPOS()
            while (!colorExists(0xDBD300)){
                Sleep, 50
            }
            delay(600,700)
            colorExists(0xFF00FF)
            movePOS()
            while (colorExists(0xDBD300)){
                if (colorExists(0x485DFF)){
                    Click,
                    Sleep, 600
                }
            }
        }
        waitForColor(0x00FFDD)
        ToolTip, Turning in potions..., 0, 0, 1
        foundPOS()
        Sleep, 3000
        deposit++
        ; === Reup the paste in Hopper after 30 orders ===
        if (deposit > 30){
            waitForColor(0xF25999)
            foundPOS()
            Sleep, 5000
            deposit := 0
        }
        ToolTip, Returing to start..., 0, 0, 1
        waitForColor(0x00FF00)
        foundPOS()
        Sleep, 4000
    }
}

; 		=== Utility Functions ===
foundPOS(){
    modX := posX + 10
	modY := posY + 15
    focusClient()
    MouseMoveL(modX, modY, 10, 2)
	Click,
}
movePOS(){
    modX := posX + 10
	modY := posY + 20
	focusClient()
	MouseMoveL(modX, modY, 10, 2)
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
focusClient(){
	WinRestore, %Title%
	WinActivate, %Title%
}
delay(min := 240, max := 440){
    Random, delay, %min%, %max%
    Sleep, delay
}
log(msg) {
    FileAppend, %A_Now% - %msg%`n, %logFile%
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