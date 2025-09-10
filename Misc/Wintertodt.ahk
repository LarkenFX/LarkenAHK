#NoEnv
#Warn
SetWorkingDir %A_ScriptDir%

; === Include shared libs ===
#Include %A_ScriptDir%\..\.libs\ClientSetup.ahk
#Include %A_ScriptDir%\..\.libs\ColorUtils.ahk
#Include %A_ScriptDir%\..\.libs\MouseUtils.ahk
#Include %A_ScriptDir%\..\.libs\Logging.ahk
initLog("todtLog.txt")

; === Global Variables ===
global posX, posY, gameBoxX, gameBoxY, bagX, bagY, Title, invFull

; === Coordinate Modes ===
SendMode, Input
CoordMode, ToolTip, Client
CoordMode, Pixel, Client
CoordMode, Mouse, Client

; === Script Guide ===
; LarkenAHK's Wintertodt Script.
; -Use the provided RuneLite profile & set game size to 1270x830 in RuneLite plugin, REQUIRED.
; -Check below in main() to ensure colors ingame are correct.
; -Have the XP tracker sidebar open before pressing SHIFT+1.
; -Camera facing SOUTHWEST seems best, make sure you can see vials box from brazier.

; === Hotkeys ===
^p::Pause, Toggle         ; Ctrl+P = Pause
^q::saveMousePos("Q")     ; Ctrl+Q = Save mouse position (mPos["Q"].x,mPos["Q"].y)
^w::saveMousePos("W")     ; Ctrl+W = Save mouse position (mPos["W"].x,mPos["W"].y)
+1::main()                ; Shift+1 = Run script

; === Main Script ===
main() {
    setUpClient()
    Sleep, 1000
    bagX := 1074
    bagY := 568
    global roots, brazier, vials, herb
    global knife, logs, kindle, wtDead, idle
    global roots := 0x0000FF
    global brazier := 0xFF00FF
    global vials := 0x7D00FF
    global herb := 0x00FFDD
    knifeCheck("knife")
    Loop {
        hpCheck()
		wtCheck()
		invCheck()
		statusCheck()
		if (knife == 0){
			if (wtDead == 0 && kindle == 1 && idle == 1){
				;brazier
                waitForColor(brazier)
                clickPos(posX, posY)
                delay(2400,3000)
			}
			if (wtDead == 0 && logs == 0 && kindle == 0 && idle == 1){
				;chop
                waitForColor(roots)
                clickPos(posX, posY)
                delay(4000,4800)
			}
			if (wtDead == 0 && logs == 1 && kindle == 0 && idle == 1){
				;brazier
                waitForColor(brazier)
                clickPos(posX, posY)
                delay(2400,3000)
			}
			if (wtDead == 1 && logs == 0){
				restock()
				knifeCheck("knife")
                ;chop
                waitForColor(roots)
                clickPos(posX, posY)
                delay(4000,4800)
				while (wtDead == 1){
					Sleep, 1000
					wtCheck()
				}
			}
		}
		if (knife == 1){
			if (wtDead == 0 && logs == 0 && kindle == 0 && idle == 1){
				;chop
                waitForColor(roots)
                clickPos(posX, posY)
                delay(4000,4800)
			}
			if (wtDead == 0 && logs == 1 && idle == 1){
				fletch()
			}
			if (wtDead == 0 && kindle == 1 && idle == 1){
				;brazier
                waitForColor(brazier)
                clickPos(posX, posY)
                delay(2400,3000)
			}
			if (wtDead == 1 && logs == 0){
				restock()
				knifeCheck("knife")
                ;chop
                waitForColor(roots)
                clickPos(posX, posY)
                delay(4000,4800)
                log("Waiting for WT respawn...", "SLEEP")
				while (wtDead == 1){
					Sleep, 1000
					wtCheck()
				}
			}
		}
	}
}

fletch(){
	searchInv(0xff00ff)
	if (ErrorLevel == 0){
		clickPos(posX, posY)
		findInvImage("knife")
		delay(600,1000)
	}

}
wtCheck(){
    global wtDead
	checkInfobox(0x00CC00, 205, 85)
	if (ErrorLevel == 1){
		wtDead := 1
	}else{
		wtDead := 0
	}
}
hpCheck(){
	checkInfobox(0x007462, 108, 85)
	if (ErrorLevel == 0){
		ToolTip, HEALING!, 0, 5, 1
		findInvImage("potion")
        log("Drank Potion", "SUCCESS")
        delay()
	}
}
statusCheck(){
    global idle
	PixelSearch, Px, Py, 4, 775, 165, 790, 0xFF0000, 1, Fast RGB
	if (ErrorLevel == 0){
		idle := 1
	}else{
		idle := 0
	}
}
invCheck(){
    global logs, kindle, knife
	checkInvFull(0xFF00FF)
	if (ErrorLevel == 0){
		logs := 1
	}else{
		logs := 0
	}
	checkInvFull(0xFF0000)
	if (ErrorLevel == 0){
		kindle := 1
		knife := 0
	}else{
		kindle := 0
	}
}
restock(){
    log("Starting restock...")
	waitTimer := 0
	delay()
    while (searchInv(0x00FF00)) {
        clickPos(posX, posY)
        delay(1500,1700)
        Send {Shift Down}
        sleep, 100
        clickPos(posX, posY)
        sleep, 100
        Send {Shift Up}
        delay(1500,1700)
    }
	waitForColor(0x7D00FF)	;Move to get vial
    clickPos(posX, posY)
	while (!searchInv(0x7D00FF)){
		Sleep, 1000
		waitTimer++
		if (waitTimer > 15){
			waitForColor(0x7D00FF)	;Move to get vial
			waitTimer := 0
		}
	}
    delay(1200,1800)
	waitForColor(0x00FFDD)	;Move to get herb
    clickPos(posX, posY)
	waitTimer := 0
	while (!searchInv(0x00FFDD)){
		Sleep, 100
		waitTimer++
		if (waitTimer > 30){
			waitForColor(0x00FFDD)	;Move to get herb
            clickPos(posX, posY)
			waitTimer := 0
		}
	}
	clickPos(posX, posY)	;Click herb to mix
	searchInv(0x7D00FF)
    clickPos(posX, posY)	;mix with vial
	delay()
    log("restock completed", "SUCCESS")
}

knifeCheck(imageName){
	global ix, iy, bagX, bagY, knife
	focusClient()
	imagePath := A_ScriptDir . "\images\" . imageName . ".png"
	if !FileExist(imagePath) {
		log("Missing image: " . imagePath)
		return
	}
	bagX2 := bagX + 167
	bagY2 := bagY + 250
	ImageSearch, ix, iy, %bagX%, %bagY%, %bagX2%, %bagY2%, *20 %imagePath%
	if (ErrorLevel == 0){
		knife := 1
	}else{
		knife := 0
	}
    log("knife status " . knife . "")
}