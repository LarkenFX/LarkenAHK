global qxP
global qyP
global wxP
global wyP
global exP
global eyP
global rxP
global ryP
global txP
global tyP

^p::Pause,Toggle

tsleep() {
	Random, r, 650, 700
	Sleep, r
}

walkSleep(){
	Random, r, 8000, 8600
	Sleep, r
}

qq(){
	MouseGetPos, qxP, qyP
	return
}

ww() {
	MouseGetPos, wxP, wyP
	return
}
ee() {
	MouseGetPos, exP, eyP
	return
}
rr(){
	MouseGetPos, rxP, ryP
	return
}


buyGoldOre(){
	loop{
		loop, 3{
			Click, %qxP%, %qyP%		;click seller
			walkSleep()
			Click, %wxP%, %wyP%		;buy ore
			tsleep()
			Click, %exP%, %eyP%		;click bank
			walkSleep()
			Click, %rxP%, %ryP%		;click first inv slot
			tsleep()
			Send {Esc}				;set esc to close interfaces in OSRS settings
		}
	tsleep()
	Send {Right}	;change {Right} to whatever your "Quick-hop next" hotkey is in World Hopper plugin
	tsleep()
	Send {Space}
	walkSleep()
	}
}

+1::buyGoldOre()

^q::qq()
^w::ww()
^e::ee()
^r::rr()

;set camera so seller is clickable with bank open, and vice versa
;make sure to set ore left click to Buy-50, and bank to deposit all
;ctrl+p will pause script
;----SETUP----
;ctrl+q seller when standing at bank
;ctrl+w ore
;ctrl+e bank standing at seller
;ctrl+r first inv slot