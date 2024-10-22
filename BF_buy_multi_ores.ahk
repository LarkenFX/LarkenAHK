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
tt(){
	MouseGetPos, txP, tyP
	return
}

buy2typeOre(){
	loop{
		loop, 2{
			Click, %qxP%, %qyP%		;click seller
			walkSleep()
			Click, %wxP%, %wyP%		;buy ore 1
			tsleep()
			Click, %rxP%, %ryP%		;click bank
			walkSleep()
			Click, %txP%, %tyP%		;click first inv slot
			tsleep()
			Click, %qxP%, %qyP%		;click seller
			walkSleep()
			Click, %exP%, %eyP%		;buy ore 2
			tsleep()
			Click, %rxP%, %ryP%		;click bank
			walkSleep()
			Click, %txP%, %tyP%		;click first inv slot
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

+1::buy2typeOre()

^q::qq()
^w::ww()
^e::ee()
^r::rr()
^t::tt()

;make sure to set ore left click to Buy-50, and bank to deposit all
;ctrl+p will pause script
;----SETUP----
;ctrl+q seller when standing at bank
;ctrl+w ore type 1
;ctrl+e ore type 2
;ctrl+r bank standing at seller
;ctrl+t first inv slot