; ==== ColorUtils.ahk ====

colorExists(hexCode) {
    global posX, posY, gameBoxX, gameBoxY
    focusClient()
    PixelSearch, posX, posY, 5, 30, %gameBoxX%, %gameBoxY%, %hexCode%, 1, Fast RGB
    return (ErrorLevel == 0)
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
		return true
	}else{
		return false
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
		return true
	}else{
		return false
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
	PixelSearch, posX, posY, %bagX1%, %bagY1%, %bagX2%, %bagY2%, %hexCode%, 1, Fast RGB
	invFull := (ErrorLevel == 0) ? 1 : 0
}

searchInv(hexCode){
	global posX, posY
	bagX2 := gameBoxX + 210
	bagY2 := gameBoxY - 15
	focusClient()
	PixelSearch, posX, posY, %bagX%, %bagY%, %bagX2%, %bagY2%, %hexCode%, 1, Fast RGB
	return !ErrorLevel
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