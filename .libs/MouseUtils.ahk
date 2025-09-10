; ==== MouseUtils.ahk ====
global mPos := {}
SendMode, Input

saveMousePos(name := "Q") {
    global mPos
    MouseGetPos, x, y
    mPos[name] := {x: x, y: y}
}

delay(min := 240, max := 440){
    Random, delay, %min%, %max%
    Sleep, delay
}

MouseMoveL(x2, y2, steps := 15, sleepTime := 3) {
    focusClient()
    MouseGetPos, x1, y1
    dx := x2 - x1
    dy := y2 - y1
    Loop, %steps% {
        i := A_Index
        progress := (1 - Cos(3.14159 * i / steps)) / 2
        x := x1 + (dx * progress)
        y := y1 + (dy * progress)
        MouseMove, %x%, %y%, 0
        Sleep, sleepTime
    }
}

MouseMoveSigmoid(x1, y1, x2, y2, steps := 30, duration := 75, k := 12) {
    dx := x2 - x1
    dy := y2 - y1
    Loop, %steps% {
        t := A_Index / steps
        s := 1 / (1 + Exp(-k * (t - 0.5))) ; Sigmoid smoothing
        x := x1 + dx * s
        y := y1 + dy * s
        MouseMove, % Round(x), % Round(y), 0
        Sleep, % Round(duration / steps)
    }
}

clickPos(x, y, offsetX := 3, offsetY := 5) {
    focusClient()
    MouseGetPos, x1, y1
    x2 := x + offsetX
    y2 := y + offsetY
    Random, randSteps, 12, 24
    Random, randK, 11, 18
    Random, randDuration, 75, 135
    MouseMoveSigmoid(x1, y1, x2, y2, randSteps, randDuration, randK)
    Click
}

;clickPos(x, y, offsetX := 10, offsetY := 15) {
   ; focusClient()
   ; MouseMoveL(x + offsetX, y + offsetY)
   ; Click
;}