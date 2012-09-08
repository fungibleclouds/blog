on GetCurrentApp()
  tell application "System Events" to get short name of first process whose frontmost is true
end GetCurrentApp

if GetCurrentApp() is equal to "TextMate" then
    tell application "Google Chrome" to activate
else
    tell application "TextMate" to activate
end if