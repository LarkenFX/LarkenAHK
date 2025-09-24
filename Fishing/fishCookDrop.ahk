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
global posX, posY, gameBoxX, gameBoxY, bagX, bagY, Title, invFull, cookedFish

; === Coordinate Modes ===
SendMode, Input
CoordMode, ToolTip, Client
CoordMode, Pixel, Client
CoordMode, Mouse, Client

; === Script Guide ===
; LarkenAHK's Edge Fishing Script.
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
    fishingSpot := 0xFF00FF
    rawFish := 0x00FFDD
    cookedFish := 0xFF0000
    fire := 0x485DFF
    Loop {
        isFishing := checkInfobox(0x00FF00)
        checkInvFull(rawFish)
        if (!isFishing && !invFull){
            waitForColor(fishingSpot)
            clickPos(posX, posY)
            Sleep, 6000
        }
        if (invFull){
            log("inv full")
            delay()
            waitForColor(fire)
            clickPos(posX, posY)
            fireTry := 0
            while (!existsGameImage("cookMenu")){
                delay()
                fireTry++
                if (fireTry > 30){
                    waitForColor(fire)
                    log("=== FIRE FAILED ===", "ERROR")
                    clickPos(posX, posY, 1, 1)
                    fireTry := 0
            }
            }
            Send, {Space}
            log("Started cooking 1")
            delay(4000,5600)
            log("checking info box")
            isCooking := checkInfobox(0x00FF00, 135, 160)
            log("am i cooking? 0 yes 1 no ")
            while (isCooking){
                delay()
                isCooking := checkInfobox(0x00FF00, 135, 160)
            }
            log("first batch cooked any raws left?")
            if (searchInv(rawFish)){
                log("searched. " . ErrorLevel . )
                waitForColor(fire)
                clickPos(posX, posY)
                fireTry := 0
                while (!existsGameImage("cookMenu")){
                    delay()
                    fireTry++
                    if (fireTry > 30){
                        waitForColor(fire)
                        log("=== FIRE FAILED ===", "ERROR")
                        clickPos(posX, posY, 1, 1)
                        fireTry := 0
                }
                log("Started cook #2")
                delay()
                Send, {Space}
                delay(2000,3200)
                isCooking := checkInfobox(0x00FF00, 135, 160)
                while (isCooking){
                    delay()
                    isCooking := checkInfobox(0x00FF00, 135, 160)
                }
            }
            dropAll(0xFF0000)
        }
        delay()
    }
}