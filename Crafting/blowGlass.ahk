#NoEnv
#Warn
SetWorkingDir %A_ScriptDir%

; === Include shared libs ===
#Include %A_ScriptDir%\..\.libs\ClientSetup.ahk
#Include %A_ScriptDir%\..\.libs\ColorUtils.ahk
#Include %A_ScriptDir%\..\.libs\MouseUtils.ahk
#Include %A_ScriptDir%\..\.libs\Logging.ahk
initLog("?log.txt")

; === Global Variables ===
global posX, posY, gameBoxX, gameBoxY, bagX, bagY, Title, invFull

; === Coordinate Modes ===
SendMode, Input
CoordMode, ToolTip, Client
CoordMode, Pixel, Client
CoordMode, Mouse, Client

; === Script Guide ===
; LarkenAHK's Glassblowing Script.
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
    global tradeWindow := 0xFF981F
    Loop {
        ToolTip, TEMPLATE SCRIPT RUNNING..., 0, 5, 1
        waitForColor(bank)
        clickPos(posX, posY)
        waitForColor(tradeWindow)
        findGameImage("deposit")
        clickPos(mPos["Q"].x,mPos["Q"].y, 2, 2)
        delay()
        Send, {Esc}
        findInvImage("pipe")
        findInvImage("glass")
        while(!existsGameImage("craftMenu")){
            delay()
        }
        delay()
        Send, {Space}
        while(existsInvImage("glass")){
            delay()
        }
    }
}