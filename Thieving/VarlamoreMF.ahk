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
; LarkenAHK's Varlamore Master Farmers Script.
; -Use the provided RuneLite profile
; Set game size to 1270x830 in RuneLite plugin + XP tracker open, REQUIRED.
; https://www.youtube.com/watch?v=Z4rPTQNW5kQ
; The above setup is the only Master Farmer in the game that works!
; Inventory tag all trash seeds > FF00FFDD
; Zoom in and angle camera so you dont get in the way of the blue box

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
    farmer := 0x0000FF
    garbage := 0x00FFDD
    while (colorExists(farmer)) {
        ppSuccess := 0
        Random, ppDrop, 10, 25
        while (colorExists(farmer)){
            clickMiddle(farmer)
            ppSuccess++
            while (!colorExists(0x7D00FF)){
                delay(20,50)
            }
            if (ppSuccess > ppDrop){
                Send, {Shift Down}
                delay(50,100)
                dropAll(garbage)
                Send, {Shift Up}
                delay(50,100)
                break
            }
        }
    }
    ExitApp
}