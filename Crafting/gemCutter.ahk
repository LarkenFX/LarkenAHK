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
global posX, posY, gameBoxX, gameBoxY, bagX, bagY, Title, invFull, gemType

; === Coordinate Modes ===
SendMode, Input
CoordMode, ToolTip, Client
CoordMode, Pixel, Client
CoordMode, Mouse, Client

; === Script Guide ===
; LarkenAHK's Gem Cutting Script.
; -Use the provided RuneLite profile & set game size to 1270x830 in RuneLite plugin, REQUIRED.
; Lock Chisel inventory spot in bank settings
; Start Script with uncut gems in inventory
; === NO HOTKEYS ARE NEEDED FOR THIS SCRIPT ===

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
    bank := 0x485DFF
    tradeWindow := 0xFF981F
    checkStatus()
    Loop {
        Send, {Esc}
        findInvImage("chisel")
        findInvImage(gemType)
        while (!existsGameImage("craftMenu")){
            delay()
        }
        Send, {Space}
        while (existsInvImage(gemType)){
            delay()
        }
        waitForColor(bank)
        clickPos(posX, posY)
        while (!colorExists(tradeWindow)){
            delay()
        }
        findGameImage("deposit")
        findGameImage(gemType)
        delay(80,220)
    }
}

checkStatus(){
    ;=== Check what type of GEM being used ===
    gemType := ""
    gemImages := ["sapp(U)", "emer(U)", "ruby(U)", "diam(U)", "dstone(U)", "opal(U)", "jade(U)", "topaz(U)"]

    for _, gem in gemImages{
        if (existsInvImage(gem)){
            gemType := gem
            break
        }
    }
    if (gemType := ""){
        MsgBox, 16, ERROR, No suitable Gems found! Check Gem images or Restart with Gems in inventory
        Reload
    }
}