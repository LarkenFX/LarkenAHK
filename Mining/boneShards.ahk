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
; LarkenAHK's Bone Shard Mining Script.
; -Use the provided RuneLite profile & set game size to 1270x830 in RuneLite plugin, REQUIRED.

; === Hotkeys ===
^p::Pause, Toggle         ; Ctrl+P = Pause
^q::saveMousePos("Q")     ; Ctrl+Q = Save mouse position (mPos["Q"].x,mPos["Q"].y)
^w::saveMousePos("W")     ; Ctrl+W = Save mouse position (mPos["W"].x,mPos["W"].y)
+1::main()                ; Shift+1 = Run script

; === Main Script ===
main() {
    setUpClient()
    bagX := 1074
    bagY := 568
    global garbage := 0xFF0000
    global rocks := 0xF25999
    Sleep, 1000
    counter := 0
    Loop {
        isMining := checkInfobox(0x00FF00) ; Green = currently mining
        checkInvFull(garbage)
        if (!isMining && !invFull) {
            cleanInventory()
            waitForColor(rocks)
            clickPos(posX, posY)
            Sleep, 3000
        }
        if (invFull) {
            break
        }
        delay()
    }
}

cleanInventory() {
    global garbage
    while(searchInv(garbage)){
        clickPos(posX, posY)
        delay(600, 800)
    }
}