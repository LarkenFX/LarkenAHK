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
; LarkenAHK's Amethyst Mining Script.
; -Use the provided RuneLite profile & set game size to 1270x830 in RuneLite plugin, REQUIRED.

; === Hotkeys ===
^p::Pause, Toggle         ; Ctrl+P = Pause
^q::saveMousePos("Q")     ; Ctrl+Q = Save mouse position (mPos["Q"].x,mPos["Q"].y)
^w::saveMousePos("W")     ; Ctrl+W = Save mouse position (mPos["W"].x,mPos["W"].y)
Tab::main()                ; Shift+1 = Run script

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
                Send, {Shift Down}
                delay()
                cleanInventory()
                delay()
                Send, {ShiftUp}
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
    ;=== Check what type of GEM being used ===
    gemImages := ["sapp(U)", "emer(U)", "ruby(U)", "diam(U)"]
    for _, gem in gemImages{
        if (existsInvImage(gem)){
            dropAllImages(gem)
        }
    }
}
