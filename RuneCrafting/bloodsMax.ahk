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
global posX, posY, gameBoxX, gameBoxY, bagX, bagY, Title, invFull

; === Coordinate Modes ===
SendMode, Input
CoordMode, ToolTip, Client
CoordMode, Pixel, Client
CoordMode, Mouse, Client

; === Script Guide ===
; LarkenAHK's Blood RuneCraft Script.
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
    global bank := 0x485DFF
    global ring := 0x485DFF
    global agil1 := 0xC8A5ED
    global agil2 := 0x54DBAF
    global agil3 := 0xC74949
    global agil4 := 0x92C550
    global ruinsTile := 0xC74949
    global altarTile := 0xF25999
    global tradeWindow := 0xFF981F
    Loop {
        findGameImage("deposit")
        loop, 2{
            clickPos(mPos["Q"].x,mPos["Q"].y, 2, 2)
            delay(50,180)
            findInvImage("coloPouch")
            delay()
        }
        clickPos(mPos["Q"].x,mPos["Q"].y, 2, 2)
        delay()
        Send, {Esc}
        delay(50,160)
        Send, {F4}
        delay(50,100)
        Send, {Shift Down}
        delay(50,100)
        findInvImage("maxCape")
        delay()
        Send, {Shift Up}
        delay(3000,4000)
        clickMiddle(ring)
        Send, q
        while (!colorExists(agil1)){
            delay(50,160)
        }
        clickMiddle(agil1)
        delay(3000,3400)
        clickMiddle(agil2)
        while (!colorExists(agil3)){
            delay(50,160)
        }
        clickMiddle(agil3)
        while (!colorExists(agil4)){
            delay(50,160)
        }
        clickMiddle(agil4)
        delay(4000,4500)
        waitForColor(ruinsTile)
        clickPos(posX, posY)
        while (!colorExists(altarTile)){
            delay(50,160)
        }
        waitForColor(altarTile)
        clickPos(posX, posY)
        while (!colorExists(0x7D00FF)){
            delay(50,160)
        }
        findInvImage("coloPouch")
        waitForColor(altarTile)
        clickPos(posX, posY)
        findInvImage("coloPouch")
        waitForColor(altarTile)
        clickPos(posX, posY)
        Send, {F4}
        findInvImage("maxCape")
        while (!colorExists(bank)){
            delay()
        }
        clickMiddle(bank)
        while (!colorExists(tradeWindow)){
            delay()
        }
    }
}