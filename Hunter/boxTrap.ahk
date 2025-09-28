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
global posX, posY, gameBoxX, gameBoxY, bagX, bagY, Title, invFull, ix, iy

; === Coordinate Modes ===
SendMode, Input
CoordMode, ToolTip, Client
CoordMode, Pixel, Client
CoordMode, Mouse, Client

; === Script Guide ===
; LarkenAHK's Box Trap Script.
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
    failedTrap := 0x660000
    caughtTrap := 0x006600
    setTrap := 0x666600
    Loop {
        if existsGameImage("timeOutGreen"){
            clickPos(ix, iy)
            while(!colorExists(0x7D00FF)){
                delay(10,15)
            }
            while(!searchMyTile(setTrap)){
                delay(10,15)
            }
            delay(1800,2000)
        }
        if existsGameImage("timeOutRed"){
            clickPos(ix, iy)
            while(!colorExists(0x7D00FF)){
                delay(10,15)
            }
            while(!searchMyTile(setTrap)){
                delay(10,15)
            }
            delay(1800,2000)
        }
        if colorExists(caughtTrap){
            clickPos(posX, posY)
            while(!colorExists(0x7D00FF)){
                delay(10,15)
            }
            while(!searchMyTile(setTrap)){
                delay(10,15)
            }
            delay(1800,2000)
        }
        if colorExists(failedTrap){
            clickPos(posX, posY)
            while(!colorExists(0x7D00FF)){
                delay(10,15)
            }
            while(!searchMyTile(setTrap)){
                delay(10,15)
            }  
            delay(1800,2000)       
        }
    }
}

searchMyTile(hexCode){
    focusClient()
    PixelSearch, posX, posY, 619, 424, 663, 472, %hexCode%, 1, Fast RGB
    return (ErrorLevel == 0)
}