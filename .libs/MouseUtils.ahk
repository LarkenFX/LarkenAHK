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

MouseMoveSigmoid(x1, y1, x2, y2, steps := 0, duration := 0, k := 12) {
    dx := x2 - x1
    dy := y2 - y1
    dist := Sqrt(dx*dx + dy*dy)

    ; === Dynamic step/duration based on distance ===
    if (!steps) {
        if (dist < 30)
            steps := 10
        else if (dist < 100)
            steps := 18
        else if (dist < 200)
            steps := 28
        else
            steps := 35
    }

    if (!duration) {
        Random, baseSpeed, 9, 14 ; ms per step
        duration := steps * baseSpeed
    }

    ; === Simulate over/undershoot ===
    Random, offsetX, -3, 3
    Random, offsetY, -3, 3
    x2s := x2 + offsetX
    y2s := y2 + offsetY

    ; === Main move with overshoot ===
    Loop, %steps% {
        t := A_Index / steps
        s := 1 / (1 + Exp(-k * (t - 0.5)))
        x := x1 + dx * s + offsetX * (1 - s)
        y := y1 + dy * s + offsetY * (1 - s)
        MouseMove, % Round(x), % Round(y), 0
        Sleep, % Round(duration / steps)
    }

    ; === Micro-correction ===
    if (offsetX != 0 or offsetY != 0) {
        Random, delayMs, 5, 25
        Sleep, delayMs

        MouseGetPos, x1c, y1c
        dx := x2 - x1c
        dy := y2 - y1c
        dist := Sqrt(dx*dx + dy*dy)
        steps := (dist < 10) ? 6 : 10
        duration := (dist < 10) ? 30 : 45

        Loop, %steps% {
            t := A_Index / steps
            s := 1 / (1 + Exp(-k * (t - 0.5)))
            x := x1c + dx * s
            y := y1c + dy * s
            MouseMove, % Round(x), % Round(y), 0
            Sleep, % Round(duration / steps)
        }
    }
}

clickPos(x, y, offsetX := 3, offsetY := 5) {
    focusClient()
    MouseGetPos, x1, y1
    x2 := x + offsetX
    y2 := y + offsetY
    Random, randSteps, 16, 30
    Random, randK, 10, 16
    MouseMoveSigmoid(x1, y1, x2, y2, randSteps, 0, randK) ; duration = 0 → auto-scale
    Click
}