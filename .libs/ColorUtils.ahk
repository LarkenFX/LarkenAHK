; ==== ColorUtils.ahk ====
#Include %A_ScriptDir%\..\.libs\GDIP_Utils.ahk

; === Color Checks ===
colorExists(hexCode) {
    global posX, posY, gameBoxX, gameBoxY
    focusClient()
    PixelSearch, posX, posY, 5, 30, %gameBoxX%, %gameBoxY%, %hexCode%, 1, Fast RGB
    return (ErrorLevel == 0)
}
searchInv(hexCode){
	global posX, posY
	bagX2 := gameBoxX + 210
	bagY2 := gameBoxY - 15
	focusClient()
	PixelSearch, posX, posY, %bagX%, %bagY%, %bagX2%, %bagY2%, %hexCode%, 1, Fast RGB
	return !ErrorLevel
}
checkInvFull(hexCode){
	global invFull
	bagX1 := gameBoxX + 175
	bagY1 := gameBoxY - 45
	bagX2 := gameBoxX + 210
	bagY2 := gameBoxY - 15
    focusClient()
	PixelSearch, posX, posY, %bagX1%, %bagY1%, %bagX2%, %bagY2%, %hexCode%, 1, Fast RGB
	invFull := (ErrorLevel == 0) ? 1 : 0
}
checkInfobox(hexCode, X := 135, Y := 70){
	global posX, posY
	focusClient()
	PixelSearch, posX, posY, 5, 30, %X%, %Y%, %hexCode%, 1, Fast RGB
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

; === Image Checks ===
findInvImage(imageName){
	global ix, iy, bagX, bagY
	focusClient()
	imagePath := A_ScriptDir . "\..\.images\" . imageName . ".png"
	if !FileExist(imagePath) {
		log("Missing image: " . imagePath)
		return
	}
	bagX2 := bagX + 167
	bagY2 := bagY + 250
	ImageSearch, ix, iy, %bagX%, %bagY%, %bagX2%, %bagY2%, *20 %imagePath%
	if (ErrorLevel = 0) {
		clickPos(ix, iy)
		return true
	}else{
		return false
	}
}
existsInvImage(imageName){
	global ix, iy, bagX, bagY
	focusClient()
	imagePath := A_ScriptDir . "\..\.images\" . imageName . ".png"
	if !FileExist(imagePath) {
		log("Missing image: " . imagePath)
		return
	}
	bagX2 := bagX + 167
	bagY2 := bagY + 250
	ImageSearch, ix, iy, %bagX%, %bagY%, %bagX2%, %bagY2%, *20 %imagePath%
	if (ErrorLevel = 0) {
		return true
	}else{
		return false
	}
}
findGameImage(imageName){
	global ix, iy, gameBoxX, gameBoxY
	focusClient()
	imagePath := A_ScriptDir . "\..\.images\" . imageName . ".png"
	if !FileExist(imagePath) {
		log("Missing image: " . imagePath)
		return
	}
	ImageSearch, ix, iy, 5, 30, %gameBoxX%, %gameBoxY%, *20 %imagePath%
	if (ErrorLevel = 0) {
		clickPos(ix, iy)
		return true
	}else{
		return false
	}
}
existsGameImage(imageName){
	global ix, iy, gameBoxX, gameBoxY
	focusClient()
	imagePath := A_ScriptDir . "\..\.images\" . imageName . ".png"
	if !FileExist(imagePath) {
		log("Missing image: " . imagePath)
		return
	}
	ImageSearch, ix, iy, 5, 30, %gameBoxX%, %gameBoxY%, *20 %imagePath%
	if (ErrorLevel = 0) {
		return true
	}else{
		return false
	}
}
findMapImage(imageName){
	global ix, iy, gameBoxX, gameBoxY
	focusClient()
	imagePath := A_ScriptDir . "\..\.images\" . imageName . ".png"
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

; === Utility ===
dropAll(hexCode) {
	global StartX, StartY, slotW, slotH, cols, rows
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
            PixelSearch, px, py, x - 6, y - 6, x + 6, y + 6, %hexCode%, 5, Fast RGB
            if (ErrorLevel == 0) {
                MouseMoveL(px + 5, py + 5, 10, 2)
                Click
                Sleep, 110  ; mimic human timing
            }
        }
    }
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
clickMiddle(hexCode) {
    global gameBoxX, gameBoxY
    focusClient()
    ; === TOP (find top Y)
    PixelSearch, _, topY, 5, 30, gameBoxX, gameBoxY, hexCode, 1, Fast RGB
    if (ErrorLevel){
        waitForColor(hexCode)
		clickPos(posX, posY)
		return false
	}
    ; === BOTTOM (find bottom Y)
    PixelSearch, _, bottomY, 5, gameBoxY, gameBoxX, 30, hexCode, 1, Fast RGB
    if (ErrorLevel){
        waitForColor(hexCode)
		clickPos(posX, posY)
		return false
	}
    ; === LEFT (find left X)
    PixelSearch, leftX, _, 5, 30, gameBoxX, gameBoxY, hexCode, 1, Fast RGB
    if (ErrorLevel){
        waitForColor(hexCode)
		clickPos(posX, posY)
		return false
	}
    ; === RIGHT (find right X)
    PixelSearch, rightX, _, gameBoxX, 30, 5, gameBoxY, hexCode, 1, Fast RGB
    if (ErrorLevel){
        waitForColor(hexCode)
		clickPos(posX, posY)
		return false
	}
    ; === CENTER ===
    centerX := (leftX + rightX) // 2
    centerY := (topY + bottomY) // 2
    MouseMoveL(centerX, centerY)
    delay(100, 150)
    ; === VERIFY COLOR BEFORE CLICK ===
    MouseGetPos, x, y
    PixelGetColor, hoveredColor, x, y, RGB
    hoveredColor := hoveredColor & 0xFFFFFF  ; Strip alpha if present
    if (hoveredColor == hexCode) {
        Click
        return true
    }else{
		waitForColor(hexCode)
		clickPos(posX, posY)
	}
}