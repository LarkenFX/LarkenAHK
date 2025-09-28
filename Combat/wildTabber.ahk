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
; LarkenAHK's Wild Tabber Script.
; -Use the provided RuneLite profile & set game size to 1270x830 in RuneLite plugin, REQUIRED.
; CTRL+Q teleport, hit TAB when ready to prime auto-tabber

; === Hotkeys ===
^p::Pause, Toggle         ; Ctrl+P = Pause
^q::saveMousePos("Q")     ; Ctrl+Q = Save mouse position (mPos["Q"].x,mPos["Q"].y)
^w::saveMousePos("W")     ; Ctrl+W = Save mouse position (mPos["W"].x,mPos["W"].y)
TAB::main()               ; TAB = Run script

; === Main Script ===
main() {
    setUpClient()
    ToolTip, TABBER PRIMED... , 0,5,1
    while (!colorExists(0x387BEA)){
        delay(15,16)
    }
    Send, {Q}
    fastClick(mPos["Q"].x, mPos["Q"].y)
    fastClick(mPos["Q"].x, mPos["Q"].y)
    fastClick(mPos["Q"].x, mPos["Q"].y)
    ToolTip
}