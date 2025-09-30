#NoEnv
#Warn
SetWorkingDir %A_ScriptDir%

; === Include shared libs ===
#Include %A_ScriptDir%\..\.libs\ClientSetup.ahk
#Include %A_ScriptDir%\..\.libs\ColorUtils.ahk
#Include %A_ScriptDir%\..\.libs\MouseUtils.ahk
#Include %A_ScriptDir%\..\.libs\Logging.ahk
#Include %A_ScriptDir%\..\.libs\GDIP_Utils.ahk
initLog()

; === Global Variables ===
global posX, posY, gameBoxX, gameBoxY, bagX, bagY, Title, invFull

; === Coordinate Modes ===
SendMode, Input
CoordMode, ToolTip, Client
CoordMode, Pixel, Client
CoordMode, Mouse, Client

; === Script Guide ===
; LarkenAHK's Potion Making Script.
; -Use the provided RuneLite profile & set game size to 1270x830 in RuneLite plugin, REQUIRED.

; === Hotkeys ===
setUpClient()
^p::Pause, Toggle         ; Ctrl+P = Pause
^q::saveMousePos("Q")     ; Ctrl+Q = Save mouse position (mPos["Q"].x,mPos["Q"].y)
^w::saveMousePos("W")     ; Ctrl+W = Save mouse position (mPos["W"].x,mPos["W"].y)
^s::setItem()             ; Ctrl+S on Unf potion
^k::setItem2()            ; Ctrl+K on Secondary item
+1::main()                ; Shift+1 = Run script

; === Main Script ===
main() {
    Sleep, 1000
    bagX := 1074
    bagY := 568
    bank := 0x485DFF
    tradeWindow := 0xFF981F
    Loop {
        Send, {Esc}
        findInvImage("item1")
        findInvImage("item2")
        while (!existsGameImage("craftMenu")){
            delay()
        }
        Send, {Space}
        while (existsInvImage("item1")){
            delay()
        }
        clickMiddle(bank)
        waitForColor(tradeWindow)
        findGameImage("deposit")
        findGameImage("item1")
        findGameImage("item2")
        delay(50,200)
    }
}