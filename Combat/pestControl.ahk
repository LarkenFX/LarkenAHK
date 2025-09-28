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
global posX, posY, gameBoxX, gameBoxY, bagX, bagY, Title, invFull, gameStatus

; === Coordinate Modes ===
SendMode, Input
CoordMode, ToolTip, Client
CoordMode, Pixel, Client
CoordMode, Mouse, Client

; === Script Guide ===
; LarkenAHK's Pest Control Script.
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
    gangplank := 0xF25999
    ladder := 0x00FFDD
    mobs := 0x485DFF
    gameStatus := 0
    ; === GAME STATUS > 0,no game > 1,waiting > 2,ingame > 3,attacking ===
    Loop {
        gameCheck()
        if (gameStatus == 1){
            clickPos(posX, posY)
            delay(15000,20000)
            gameStatus := 2
        }
        if (gameStatus == 2){
            noXP := 0
            radSearch(mobs)
            clickPos(posX, posY)
            gameStatus := 3
            while (!colorExists(0x7D00FF)){
                delay()
                noXP++
                if (noXP > 30){
                    gameStatus := 2
                }
            }
        }
    }
}

gameCheck(){
    if (colorExists(gangplank)){
        gameStatus := 0
        clickMiddle(gangplank)
        waitForColor(ladder)
        gameStatus := 1
    }
}