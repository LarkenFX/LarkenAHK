#NoEnv
#Warn
SetWorkingDir %A_ScriptDir%

; === Include shared libs ===
#Include %A_ScriptDir%\..\.libs\ClientSetup.ahk
#Include %A_ScriptDir%\..\.libs\ColorUtils.ahk
#Include %A_ScriptDir%\..\.libs\MouseUtils.ahk
#Include %A_ScriptDir%\..\.libs\Logging.ahk
initLog()

; === Global Variables ===
global posX, posY, gameBoxX, gameBoxY, bagX, bagY, Title, invFull, gameState

; === Coordinate Modes ===
SendMode, Input
CoordMode, ToolTip, Client
CoordMode, Pixel, Client
CoordMode, Mouse, Client

; === Script Guide ===
; LarkenAHK's GOTR Script.
; -Use the provided RuneLite profile & set game size to 1270x830 in RuneLite plugin, REQUIRED.

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
    invFull := 0
    craftTable := 0xF25999
    guardian := 0xFF00FF
    agil := 0x92C550
    agil2 := 0x8A50C5
    mine := 0x54DBAF
    statue := 0x33FF99
    portal := 0x485DFF
    altar := 0xC74949
    ess := 0x7D00FF
    xpDrop := 0x7D00FF
    repair := 3
    craftTicks := 0
    Loop {
        checkState()
        while (!existsGameImage("gotrStart")){
            delay()
        }
        clickMiddle(mine)
        delay(150000,155000)
        clickMiddle(agil2)
        delay(5800,6300)
        clickMiddle(craftTable)
        while (invFull == 0 && gameState == 1){
            Sleep, 200
            craftTicks++
            ToolTip, %craftTicks%, 0,5,1
            checkInvFull(ess)
            if (craftTicks == 27){
                findInvImage("largePouch")
                findInvImage("medPouch")
                clickMiddle(craftTable)
            }
            checkState()
        }
        while (colorExistsInv(0x00FFDD) && gameState == 1){
            invFull := 0
            waitForColor(statue)
            clickPos(posX, posY)
            teleTry := 0
            while (!colorExists(altar)){
                Sleep, 100
                teleTry++
                ToolTip, %teleTry%, 0,5,1
                if (teleTry > 30){
                    waitForColor(statue)
                    clickPos(posX, posY)
                    teleTry := 0
                }
            }
            clickMiddle(altar)
            while (!colorExists(xpDrop)){
                delay(50,160)
            }
            findInvImage("largePouch")
            findInvImage("medPouch")
            clickMiddle(altar)
            delay(80,200)
            clickMiddle(portal)
            while (!colorExists(guardian)){
                delay(50,160)
                checkState()
            }
            if (gameState == 0){
                clickMiddle(guardian)
                break
            }
            clickMiddle(0x0000FF)
            delay(2600,2800)
            clickMiddle(craftTable)
            craftTicks := 0
            while (invFull == 0 && gameState == 1){
                Sleep, 200
                craftTicks++
                checkInvFull(ess)
                if (craftTicks == 17){
                    findInvImage("largePouch")
                    findInvImage("medPouch")
                    clickMiddle(craftTable)
                }
                checkState()
            }
            clickMiddle(guardian)
            while (!colorExists(xpDrop)){
                delay(50,160)
                checkState()
            }
        }
        while (existsGameImage("gotrPower")){
            delay()
        }
        repair++
        if (repair > 3){
            Send, e
            delay()
            findInvImage("npcContact")
            while (!existsGameImage("chatCont")){
                delay()
            }
            Send, {Space}
            while (!existsGameImage("npcRepair")){
                delay()
            }
            Send, {1}
            while (!existsGameImage("chatCont")){
                delay()
            }
            Send, {Space}
            repair := 0
        }
        clickMiddle(agil)
        delay()
        Send, q
    }
}


checkState(){
    global ix, iy
	focusClient()
	imagePath := A_ScriptDir . "\..\.images\gotrPower.png"
	if !FileExist(imagePath) {
		log("Missing image: " . imagePath)
		return
	}
	ImageSearch, ix, iy, 5, 30, 175, 75, *20 %imagePath%
	if (ErrorLevel = 0) {
		gameState := 0
	}else{
		gameState := 1
	}
}