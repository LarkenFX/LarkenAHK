; ==== ClientSetup.ahk ====

setUpClient() {
    global gameBoxX, gameBoxY, Title
    SysGet, res, MonitorWorkArea
    SetTitleMatchMode, 2
    Title := "RuneLite"
    GetClientSize(WinExist(Title), wcW, wcH)
    gameBoxX := wcW - 526
    gameBoxY := wcH - 32
}
GetClientSize(hWnd, ByRef w := "", ByRef h := "") {
    VarSetCapacity(rect, 16)
    DllCall("GetClientRect", "ptr", hWnd, "ptr", &rect)
    w := NumGet(rect, 8, "int")
    h := NumGet(rect, 12, "int")
}

focusClient() {
    global Title
    WinRestore, %Title%
    WinActivate, %Title%
}

relogCheck() {
    global ix, iy
    if existsGameImage("playNow"){
        clickPos(ix, iy)
        while (!existsGameImage("clickHere")){
            delay(4000,10000)
        }
        findGameImage("clickHere")
    }
}