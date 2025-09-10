; ==== MouseUtils.ahk ====
global mPos := {}
SendMode, Input

saveMousePos(name := "Q") {
    global mPos
    MouseGetPos, x, y
    mPos[name] := {x: x, y: y}
}

delay(min := 240, max := 440){
    Random, delay, %min%, %max%
    Sleep, delay
}

MouseMoveL(x2, y2, steps := 15, sleepTime := 3) {
    focusClient()
    MouseGetPos, x1, y1
    dx := x2 - x1
    dy := y2 - y1
    Loop, %steps% {
        i := A_Index
        progress := (1 - Cos(3.14159 * i / steps)) / 2
        x := x1 + (dx * progress)
        y := y1 + (dy * progress)
        MouseMove, %x%, %y%, 0
        Sleep, sleepTime
    }
}

MouseMoveSigmoid(x1, y1, x2, y2, steps := 30, duration := 200, k := 10) {
    dx := x2 - x1
    dy := y2 - y1
    Loop, %steps% {
        t := A_Index / steps
        s := 1 / (1 + Exp(-k * (t - 0.5))) ; Sigmoid smoothing
        x := x1 + dx * s
        y := y1 + dy * s
        MouseMove, % Round(x), % Round(y), 0
        Sleep, % Round(duration / steps)
    }
}

clickPos(x, y, offsetX := 8, offsetY := 12) {
    focusClient()
    MouseGetPos, x1, y1
    x2 := x + offsetX
    y2 := y + offsetY
    Random, randSteps, 20, 33
    Random, randK, 8, 15
    Random, randDuration, 75, 135
    MouseMoveSigmoid(x1, y1, x2, y2, randSteps, randDuration, randK)
    Click
}
; ==== ColorUtils.ahk ====

colorExists(hexCode) {
    global posX, posY, gameBoxX, gameBoxY
    focusClient()
    PixelSearch, posX, posY, 5, 30, %gameBoxX%, %gameBoxY%, %hexCode%, 1, Fast RGB
    return (ErrorLevel == 0)
}

waitForColor(hexCode) {
    global posX, posY, gameBoxX, gameBoxY
    loop {
        focusClient()
        PixelSearch, posX, posY, 5, 30, %gameBoxX%, %gameBoxY%, %hexCode%, 1, Fast RGB
        if (ErrorLevel == 0)
            break
		Sleep, 100
    }
}

findInvImage(imageName){
	global ix, iy, bagX, bagY
	focusClient()
	imagePath := A_ScriptDir . "\images\" . imageName . ".png"
	if !FileExist(imagePath) {
		log("Missing image: " . imagePath)
		return
	}
	bagX2 := bagX + 167
	bagY2 := bagY + 250
	ImageSearch, ix, iy, %bagX%, %bagY%, %bagX2%, %bagY2%, *20 %imagePath%
	if (ErrorLevel = 0) {
		clickPos(ix, iy)
	}
}

findGameImage(imageName){
	global ix, iy, gameBoxX, gameBoxY
	focusClient()
	imagePath := A_ScriptDir . "\images\" . imageName . ".png"
	if !FileExist(imagePath) {
		log("Missing image: " . imagePath)
		return
	}
	ImageSearch, ix, iy, 5, 30, %gameBoxX%, %gameBoxY%, *20 %imagePath%
	if (ErrorLevel = 0) {
		clickPos(ix, iy)
	}	
}

findMapImage(imageName){
	global ix, iy, gameBoxX, gameBoxY
	focusClient()
	imagePath := A_ScriptDir . "\images\" . imageName . ".png"
	if !FileExist(imagePath) {
		log("Missing image: " . imagePath)
		return false
	}
	; Estimate search area based on compass location
	x1 := gameBoxX
	y1 := gameBoxY - 830
	x2 := gameBoxX + 250
	y2 := gameBoxY - 600
	ImageSearch, ix, iy, %x1%, %y1%, %x2%, %y2%, *40 %imagePath%
	if (ErrorLevel = 0) {
		log("Found compass at " . ix . ", " . iy)
		clickPos(ix, iy)
		return true
	} else {
		log("Failed to find compass: " . imagePath)
		return false
	}
}

checkInvFull(hexCode){
	global invFull
	bagX1 := gameBoxX + 175
	bagY1 := gameBoxY - 45
	bagX2 := gameBoxX + 210
	bagY2 := gameBoxY - 15
    focusClient()
	PixelSearch, PosX, PosY, %bagX1%, %bagY1%, %bagX2%, %bagY2%, %hexCode%, 1, Fast RGB
	invFull := (ErrorLevel == 0) ? 1 : 0
}

radSearch(hexCode, centerX := 640, centerY := 440, maxRadius := 400, step := 10, angleStep := 20) {
	global posX, posY, gameBoxX, gameBoxY
	focusClient()
	loopRadius := 0
	maxSteps := Ceil(maxRadius / step)
	Loop, %maxSteps% {
		r := A_Index * step
		Loop, % 360 // angleStep {
			theta := A_Index * angleStep * (3.14159 / 180) ; degrees to radians
			x := centerX + Round(r * Cos(theta))
			y := centerY + Round(r * Sin(theta))
			; Skip if outside game box boundaries
			if (x < 5 || x > gameBoxX || y < 30 || y > gameBoxY)
				continue
			PixelGetColor, foundColor, x, y, RGB
			if (foundColor = hexCode) {
				posX := x
				posY := y
				return true
			}
		}
	}
	return false
}
; ==== ClientSetup.ahk ====

setUpClient() {
    global gameBoxX, gameBoxY, Title
    SysGet, res, MonitorWorkArea
    SetTitleMatchMode, 2
    Title := "RuneLite"
    GetClientSize(WinExist(Title), wcW, wcH)
    gameBoxX := wcW - 526
    gameBoxY := wcH - 32
}
GetClientSize(hWnd, ByRef w := "", ByRef h := "") {
    VarSetCapacity(rect, 16)
    DllCall("GetClientRect", "ptr", hWnd, "ptr", &rect)
    w := NumGet(rect, 8, "int")
    h := NumGet(rect, 12, "int")
}

focusClient() {
    global Title
    WinRestore, %Title%
    WinActivate, %Title%
}
; === Logging.ahk ===
global logFile

; Initialize log file (call this once)
initLog(file := "script.log") {
    global logFile
    logFile := A_ScriptDir . "\" . file
    FileDelete, %logFile%  ; start fresh
    FormatTime, readableTime, %A_Now%, yyyy-MM-dd hh:mm tt
    FileAppend, ==== Script started at %readableTime% ====`n, %logFile%
}

; Log a message with timestamp
log(msg, tag := "") {
    global logFile
    FormatTime, timestamp,, yyyy-MM-dd hh:mm tt
    FileAppend, [%timestamp%] [%tag%] %msg%`n, %logFile%
}