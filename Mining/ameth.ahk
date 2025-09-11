#NoEnv
#Warn
SetWorkingDir %A_ScriptDir%

; === Include shared libs ===
#Include %A_ScriptDir%\..\.libs\ClientSetup.ahk
#Include %A_ScriptDir%\..\.libs\ColorUtils.ahk
#Include %A_ScriptDir%\..\.libs\MouseUtils.ahk
#Include %A_ScriptDir%\..\.libs\Logging.ahk
initLog("miningLog.txt")

; === Global Variables ===
global posX, posY, gameBoxX, gameBoxY, bagX, bagY, Title, invFull

; === Coordinate Modes ===
SendMode, Input
CoordMode, ToolTip, Client
CoordMode, Pixel, Client
CoordMode, Mouse, Client

; === Script Guide ===
; LarkenAHK's Max Cape Karambwan Fishing Script.
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
    global ameth := 0x00FFDD
    global gems := 0xFF0000
    global rocks := 0xF25999
    global counter
    Sleep, 1000
    counter := 0
    Loop {
        Loop {
            isMining := checkInfobox(0x00FF00) ; Green = currently mining
            checkInvFull(ameth)                ; 
            if (!isMining && !invFull) {
                log("Not mining & inventory not full")
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
        counter += 26
        log("Inventory full - mined " . counter . " so far.")
        findInvImage("chisel")
        searchInv(ameth)
        clickPos(posX, posY)
        delay(800,1200)
        Send, {Space}
        while(searchInv(ameth)){
            delay()
        }
    }
}

cleanInventory() {
    global gems
    log("Checking for gems to drop...")
    while(searchInv(gems)){
        clickPos(posX, posY)
        delay(600, 800)
    }
}