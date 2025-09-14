#NoEnv
#Warn
SetWorkingDir %A_ScriptDir%

; === Include shared libs ===
#Include %A_ScriptDir%\..\.libs\ClientSetup.ahk
#Include %A_ScriptDir%\..\.libs\ColorUtils.ahk
#Include %A_ScriptDir%\..\.libs\MouseUtils.ahk
#Include %A_ScriptDir%\..\.libs\Logging.ahk
initLog("CranesLog.txt")    ; initialize log file

; === Global Variables ===
global posX, posY, gameBoxX, gameBoxY, bagX, bagY, Title, invFull, ix, iy

; === Coordinate Modes ===
SendMode, Input
CoordMode, ToolTip, Client
CoordMode, Pixel, Client
CoordMode, Mouse, Client

; === Hotkeys ===
^p::Pause, Toggle         ; Ctrl+P = Pause
^q::saveMousePos("Q")     ; Ctrl+Q = Save mouse position (mPos["Q"].x,mPos["Q"].y)
^w::saveMousePos("W")     ; Ctrl+W = Save mouse position (mPos["W"].x,mPos["W"].y)
+1::main()                ; Shift+1 = Run script

; === Main Script ===
main() {
    setUpClient()
    Sleep, 1000
    global gateColor := 0xFF00FF
    global mortonTile := 0xC74949
    global tradeWindow := 0xFF981F
    global razDoor := 0x00FFDD
    global planks := 0x485DFF
    bagX := 1074
    bagY := 568
    Loop {
        Send, {F7}
        delay()
        ; Click mory legs to tele to Rott
        findInvImage("moryLegs")
        ; wait for gate, click gate and wait 5-6 seconds
        waitForColor(gateColor)
        clickPos(posX, posY, 1, 1)
        razTry := 0
        while (!colorExists(mortonTile)){
            delay()
            razTry++
            if (razTry > 20){
                relogCheck()
                waitForColor(gateColor)
                log("=== GATE FAILED ===", "ERROR")
                clickPos(posX, posY, 1, 1)
                razTry := 0
            }
        }
        delay(1800,2400)
        ; after gate click red tile toward Raz
        waitForColor(mortonTile)
        clickPos(posX, posY)
        ; open raz door
        waitForColor(razDoor)
        clickPos(posX, posY)
        log("Clicked Raz Door...", "SUCCESS")
        ; wait for door to open
        razTry := 0
        while (colorExists(razDoor)){
            delay()
            razTry++
            if (razTry > 20){
                relogCheck()
                log("=== FAILED TO OPEN RAZ DOOR ===", "ERROR")
                colorExists(razDoor)
                clickPos(posX, posY)
                razTry := 0
            }
        }
        ; move inside raz house
        delay(1000,1500)
        Send, {Shift Down}
        delay()
        waitForColor(mortonTile)
        clickPos(posX, posY, 2, 2)
        delay(1600,2000)
        Send, {Shift Up}
        checkInvFull(planks)
        while (invFull == 0){
            razTry := 0
            while (!colorExists(0x7D00FF)){
                delay()
                relogCheck()
            }
            clickPos(posX, posY, 2, 2)
            ; wait for raz to transform, if doesnt in 5 waits, click raz again
            while (colorExists(0x7D00FF)){
                delay()
                razTry++
                if (razTry > 5){
                    relogCheck()
                    waitForColor(0x7D00FF)
                    log("Retry Humanize...", "RETRY")
                    clickPos(posX, posY, 2, 2)
                    razTry := 0
                }
            }
            delay(700,800)
            waitForColor(gateColor)
            clickPos(posX, posY, 2, 2)
            razTry := 0
            ; wait for trade screen, if not visible in 5 waits, click raz again
            while (!colorExists(tradeWindow)){
                ToolTip, traded raz waiting for trade %razTry%..., 0, 0, 1
                delay()
                razTry++
                if (razTry > 5){
                    relogCheck()
                    waitForColor(gateColor)
                    log("Retry Trade...", "RETRY")
                    clickPos(posX, posY, 2, 2)
                    razTry := 0
                }
            }
            clickPos(mPos["Q"].x,mPos["Q"].y, 2, 2)
            ToolTip,
            log("Bought planks.")
            delay()
            Send, {Esc}
            delay()
            Send, {q}
            delay()
            checkInvFull(planks)
            if (invFull == 1){
                log("Inv Status: Full")
                break
            }
            findInvImage("plankSack")
            delay()
            Send, {Right}
            log("Hopping... Inv Status:" . %invFull%)
            ; ============== DELAY HERE TO WAIT FOR HOP ============
            ;delay(3500,6000)
        }
        Send, {F7}
        delay()
        findInvImage("book")
        log("Waiting to arrive in pisc")
        delay()
        Send, {q}
        ; wait to arrive in pisc
        waitForColor(0x54DBAF)
        log("Arrived at book tele.")
        xpDrop := 1
        xpWaiter := 0
        ; Until 17 repairs, click Crane & wait for xp drop
        while (xpDrop < 18){
            if (colorExists(0xF25999)) {
                clickPos(posX, posY)
                ToolTip, Repairing Crane #%xpDrop%, 0,5,1
                log("Attempting to repair Crane...")
                while (!colorExists(0x7D00FF)){
                    Sleep, 100
                    xpWaiter++
                    if (xpWaiter > 330){
                        relogCheck()
                        colorExists(0xF25999)
                        clickPos(posX, posY)
                        log("XP Drop took too long, retrying...", "RETRY")
                        xpWaiter := 0
                    }
                }
                xpDrop++
                log("Crane #" . xpDrop . " in " . Format("{:.1f}", xpWaiter*100/1000) . "s", "SUCCESS")
                xpWaiter := 0
                if (xpDrop == 18){
                    break
                }
                if (colorExists(0xF25999)) {
                    delay(3600, 5000)
                }
            } else {
                Send, {Right}
                log("No repairable Cranes, hopping...")
                while(!colorExists(0xF25999)){
                    delay()
                    relogCheck()
                }
            }
        }
        log("Finished 17 repairs, restocking planks.", "SUCCESS")
    }
}