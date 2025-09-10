#NoEnv
#Warn
SetWorkingDir %A_ScriptDir%

; === Include shared libs ===
#Include %A_ScriptDir%\..\.libs\ClientSetup.ahk
#Include %A_ScriptDir%\..\.libs\ColorUtils.ahk
#Include %A_ScriptDir%\..\.libs\MouseUtils.ahk
#Include %A_ScriptDir%\..\.libs\Logging.ahk

; === Global Variables ===
global posX, posY, gameBoxX, gameBoxY, bagX, bagY, Title, invFull

; === Coordinate Modes ===
SendMode, Input
CoordMode, ToolTip, Client
CoordMode, Pixel, Client
CoordMode, Mouse, Client

; === Hotkeys ===
^p::Pause, Toggle         ; Ctrl+P = Pause
^q::saveMousePos("Q")     ; Ctrl+Q = Save mouse position (mPos["Q"].x,mPos["Q"].y)
^w::saveMousePos("W")     ; Ctrl+W = Save mouse position (mPos["W"].x,mPos["W"].y)
+1::main()                ; Shift+1 = Run script

; === Main Script ===
main() {
    setUpClient()
    Sleep, 1000
    global bank := 0x485DFF
    global ladder := 0x0000FF
    global rocks := 0xFF00FF
    global ruinsTile := 0xC74949
    global altarTile := 0xF25999
    global tradeWindow := 0xFF981F
    bagX := 1074
    bagY := 568
    Loop {
        ToolTip, NATURE SCRIPT RUNNING..., 0, 5, 1
        Send, {Shift Down}
        delay(100,210)
        findInvImage("diaryCape")
        delay()
        Send, {Shift Up}
        waitForColor(bank)
        clickPos(posX, posY)
        waitForColor(tradeWindow)
        delay()
        loop, 2{
            clickPos(mPos["Q"].x,mPos["Q"].y, 2, 2)
            delay(100,180)
            findInvImage("coloPouch")
            delay()
        }
        clickPos(mPos["Q"].x,mPos["Q"].y, 2, 2)
        delay()
        Send, {Esc}
        findInvImage("diaryCape")
        waitForColor(ladder)
        clickPos(posX, posY)
        waitForColor(rocks)
        clickPos(posX, posY)
        delay(10000,12000)
        waitForColor(ruinsTile)
        clickPos(posX, posY)
        waitForColor(altarTile)
        clickPos(posX, posY)
        delay(1200,1600)
        loop, 2{
            findInvImage("coloPouch")
            waitForColor(altarTile)
            clickPos(posX, posY)
        }
        delay()
    }
}