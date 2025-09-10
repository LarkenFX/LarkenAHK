#NoEnv
#Warn
SetWorkingDir %A_ScriptDir%

; === Include shared libs ===
#Include %A_ScriptDir%\..\.libs\ClientSetup.ahk
#Include %A_ScriptDir%\..\.libs\ColorUtils.ahk
#Include %A_ScriptDir%\..\.libs\MouseUtils.ahk
#Include %A_ScriptDir%\..\.libs\Logging.ahk
initLog("fishingLog.txt")    ; initialize log file

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
; -Check below in main() to ensure colors ingame are correct.
; ------ CHANGE SCRIPT FKEYS TO YOUR FKEYS IN GAME ------
; -Equip max cape + Rada's Blessing.
; -Have the XP tracker sidebar open before pressing SHIFT+1.
; -Camera facing WEST seems best.

; === Hotkeys ===
^p::Pause, Toggle         ; Ctrl+P = Pause
^q::saveMousePos("Q")     ; Ctrl+Q = Save mouse position (mPos["Q"].x,mPos["Q"].y)
^w::saveMousePos("W")     ; Ctrl+W = Save mouse position (mPos["W"].x,mPos["W"].y)
+1::main()                ; Shift+1 = Run script

; === Main Script ===
main() {
    setUpClient()
    Sleep, 1000
    global karams := 0x00FFDD   ; Raw karambwans in invent
    global fairyRing := 0x485DFF    ; POH Tree/Ring combo
    global fishingSpot := 0xFF00FF  ; Karam fishing spot
    global depositBox := 0x00FF00   ; Crafting guild deposit box
    global tradeWindow := 0xFF981F  ; unchangable
    bagX := 1074
    bagY := 568
    fishCount := 0
    Send, {F4}  ; === SET FKEY TO EQUIPMENT TAB!! ===    
    Loop {
        delay(150, 210)
        Send, {Shift Down}
        delay(150, 210)
        findInvImage("maxCape")
        delay()
        Send, {Shift Up}
        ; Wait to arrive in poh then click the fairy ring
        log("Teleporting to POH...")
        waitForColor(fairyRing)
        delay(3000,4000)
        waitForColor(fairyRing)
        clickPos(posX, posY)
        log("Using Fairy Ring...")
        ; Click fishing spot
        waitForColor(fishingSpot)
        clickPos(posX, posY)
        delay()
        Send, {Esc} ; === SET FKEY TO INVENTORY!! ===
        delay(5000,6500)
        checkInvFull(karams)
        while (InvFull == 0){
            if (colorExists(0xFF0000)){
                checkInvFull(karams)
                if (InvFull == 0){
                    log("Something went wrong during fishing!", "ERROR")
                    waitForColor(fishingSpot)
                    clickPos(posX, posY)
                }
            }
            delay(800,4300)
        }
        log("Inventory is full")
        Send, {F4}  ; === SET FKEY TO EQUIPMENT TAB!! ===
        delay(150, 210)
        findInvImage("maxCape")
        delay()
        waitForColor(depositBox)
        clickPos(posX, posY)
        waitForColor(tradeWindow)
        findGameImage("depositInv")
        fishCount := fishCount + 26
        log("Deposited " . fishCount . " bwans so far!", "SUCCESS")
        invFull := 0
    }
}