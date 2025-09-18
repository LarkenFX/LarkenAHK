; === Logging.ahk ===
global logFile

; Initialize log file (call this once)
initLog(file := "DEBUG.log") {
    global logFile
    logFile := A_ScriptDir . "\..\" . file
    FileDelete, %logFile%  ; start fresh
    FormatTime, readableTime, %A_Now%, yyyy-MM-dd hh:mm tt
    FileAppend, ==== Script started at %readableTime% ====`n, %logFile%
}

; Log a message with timestamp
log(msg, tag := "") {
    global logFile
    FormatTime, timestamp,, yyyy-MM-dd hh:mm tt
    FileAppend, [%timestamp%] [%tag%] %msg%`n, %logFile%
}