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

^p::Pause, Toggle 	; Ctrl+P to pause
^q::saveMousePos("Q")     ; Ctrl+Q = Save mouse position (mPos["Q"].x,mPos["Q"].y)
+1::crabFight()		; SHIFT+# to start script

;		=== Setup ===
;	-Mark crab 0xFF00FF (pink) & all tunnels 0x00FFDD (cyan).
;	-Ctrl+Q on Dragon Battleaxe if needed. 
;	-Have the XP tracker sidebar open before start.

;		=== Main Script ===
crabFight(){
	startUp()
	setUpClient()
	sleep, 1000
	tunnel := 0x00FFDD
	crab := 0xFF00FF
	fightTile := 0x0000FF
	loop{
		while (!colorExists(crab)){
			delay()
		}
		waitForColor(fightTile)
		clickMiddle(fightTile)
		while(colorExists(crab)){
			ToolTip, Fighting Crab..., 0, 5, 1
			Sleep, 30000
		}
		ToolTip, Crab is dead..., 0, 5, 1
		;=== if using Dragon Battleaxe specs ===
		if (mPos["Q"].x > 0){
			clickPos(mPos["Q"].x,mPos["Q"].y, 2, 2)
			delay()
			findMapImage("specOrb")
			delay()
			clickPos(mPos["Q"].x,mPos["Q"].y, 2, 2)
			delay()
		}
		waitForColor(tunnel)
		clickPos(posX, posY)
		sleep, 3000
	}
}

startUp(){
	MsgBox, 1, LarkenAHK,
	(
	LarkenAHK's GemCrab Script.
	
	-Use the provided RuneLite profile.
	-Mark crab 0xFF00FF (pink) & all tunnels 0x00FFDD (cyan).
	-Ctrl+Q on Dragon Battleaxe if using.
	-Have the XP tracker sidebar open before start.
	-Crab must be on screen currently before start.
	
	Press OK if settings are correct & script will start. 
	Press Cancel to make changes & use Shift+1 afterward.
	)
	ifMsgBox Cancel
	{
		Reload
	}
}