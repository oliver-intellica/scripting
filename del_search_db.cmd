net stop "Windows Search"
del C:\ProgramData\Microsoft\Search\Data\Applications\Windows\Windows.edb
net start "Windows Search"
pause
