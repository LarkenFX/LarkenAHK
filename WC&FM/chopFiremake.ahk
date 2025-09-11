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
; LarkenAHK's Chop & Firemake Script.
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
    global tree := 0x485DFF
    global logs := 0xFF0000
    global startTile := 0xF25999
    Loop {
        Loop {
            isCutting := checkInfobox(0x00FF00) ; Green = currently cutting
            checkInvFull(logs)                ; 
            if (!isCutting && !invFull) {
                log("Not cutting & inventory not full")
                waitForColor(tree)
                clickPos(posX, posY)
                delay(9000,12100)
            }
            if (invFull) {
                break
            }
            delay()
        }
        log("Inventory full")
        waitForColor(0xF25999)
        clickPos(posX, posY)
        delay(5000,7000)
        findInvImage("tinderbox")
        while(searchInv(logs)){
            searchInv(logs)
            clickPos(posX, posY)
            findInvImage("tinderbox")
            waitForColor(0x7D00FF)
        }
    }
}