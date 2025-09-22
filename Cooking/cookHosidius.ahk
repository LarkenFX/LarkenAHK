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
; LarkenAHK's Hosidius Cooking Script.
; -Use the provided RuneLite profile & set game size to 1270x830 in RuneLite plugin, REQUIRED.
; inventory tag raw food to 00FFDD & CTRL+Q raw food in bank
; While bank interface is open, angle camera to see range

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
    global stove := 0xF25999
    global bank := 0x485DFF
    global tradeWindow := 0xFF981F
    Loop {
        waitForColor(bank)
        clickPos(posX, posY)
        log("clicked bank")
        log("waiting for bank interface")
        waitForColor(tradeWindow)
        findGameImage("deposit")
        log("assume deposit found")
        clickPos(mPos["Q"].x,mPos["Q"].y, 2, 2)
        log("clicked raw food")
        waitForColor(stove)
        clickPos(posX, posY)
        log("clicked range")
        while(!existsGameImage("cookMenu")){
            delay()
        }
        Send, {Space}
        log("Cooking, waiting...")
        while(searchInv(0x00FFDD)){
            delay()
        }
    }
}