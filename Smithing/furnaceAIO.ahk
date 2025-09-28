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
global posX, posY, gameBoxX, gameBoxY, bagX, bagY, Title, invFull, barType

; === Coordinate Modes ===
SendMode, Input
CoordMode, ToolTip, Client
CoordMode, Pixel, Client
CoordMode, Mouse, Client

; === Script Guide ===
; LarkenAHK's Furnace AIO Script.
; -Use the provided RuneLite profile & set game size to 1270x830 in RuneLite plugin, REQUIRED.
; Set Withdraw X to 13 for jewelery, Withdraw All for anything else.
; Start Script with choice of bars in inventory & make atleast 1 of what you're smelting per login!
; Lock mould inventory spot in bank settings.
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
    furnace := 0xF25999
    bank := 0x485DFF
    tradeWindow := 0xFF981F
    checkStatus()
    Loop {
        Send, {Esc}
        waitForColor(furnace)
        clickPos(posX, posY)
        if (barType == "steelBar"){
            while (!existsGameImage("craftMenu")){
                delay()
            }
        }else{
            while (!existsGameImage("smithMenu")){
                delay()
            }
        }
        Send, {Space}
        delay()
        while (existsInvImage(barType)){
            delay()
        }
        waitForColor(bank)
        clickPos(posX, posY)
        while (!colorExists(tradeWindow)){
            delay()
        }
        findGameImage("deposit")
        findGameImage(barType)
        if (!gemType == ""){
            findGameImage(gemType)
        }
        delay(80,250)
    }
}

checkStatus(){
    ;=== Check what type of bar being used ===
    barType := ""
    gemType := ""
    barImages := ["silverBar", "goldBar", "steelBar"]
    gemImages := ["sapp", "emer", "ruby", "diam", "dstone", "opal", "jade", "topaz"]
    for _, bar in barImages{
        if (existsInvImage(bar)){
            barType := bar
            break
        }
    }
    if (barType := ""){
        MsgBox, 16, ERROR, No suitable Bars found! Check bar images or Restart with bars in inventory
        Reload
    }
    for _, gem in gemImages{
        if (existsInvImage(gem)){
            gemType := gem
            break
        }
    }
}