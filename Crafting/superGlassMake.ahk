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
; LarkenAHK's SGM 3/18 + 2/12 Script.
; -Use the provided RuneLite profile & set game size to 1270x830 in RuneLite plugin, REQUIRED.
; -Set withdraw X in bank to 18 or 12, then set back to withdraw 1.
; -To set to 2/12 mode, add a ; to the labeled section in code below.
; -Any Bank can be used (color it FF485DFF), RuneLite Profile is setup at North Fossil Island bank chest.

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
    global tradeWindow := 0xFF981F
    Loop {
        waitForColor(bank)
        clickPos(posX, posY)
        waitForColor(tradeWindow)
        findGameImage("deposit")
        ; CTRL+Q on giant seaweed
        clickPos(mPos["Q"].x,mPos["Q"].y, 2, 2)
        delay(140,175)
        Click
        ;   === vvv ===
        delay(140,175)    ; PUT ; INFRONT OF BOTH LINES IN THIS SECTION BETWEEN ARROWS
        Click           ; TO DO 2/12 GLASSMAKING, SET WITHDRAW X TO 12
        ;   === ^^^ ===
        delay(140,175)
        Send, {z down}
        delay(140,175)
        ; CTRL+W sand, set withdraw X to 18 or 12
        clickPos(mPos["W"].x,mPos["W"].y, 2, 2)
        delay()
        Send, {z Up}
        delay(140,200)
        Send, {Esc}
        delay()
        findInvImage("spell")
        delay(2000,3200)
    }
}