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
; LarkenAHK's Varlamore Master Farmers Script.
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
    global hold := 0x92C550
    global salvager := 0xC8A5ED
    global tradeWindow := 0xFF981F
    global garbage := 0xFF0000
    Loop {
        ToolTip, Sleeping for Salvage..., 0, 5, 1
        Sleep, 120000
        clickMiddle(hold)
        waitForColor(tradeWindow)
        clickPos(mPos["Q"].x,mPos["Q"].y, 2, 2)
        clickMiddle(salvager)
        while colorExistsInv(0x00FFDD){
            Sleep, 3000
        }
        Sleep, 150
        Send {Shift Down}
        Sleep, 300
        dropAll(garbage)
        Sleep, 300
        Send {Shift Up}
    }
}