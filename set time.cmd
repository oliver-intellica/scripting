REM lets set some reliable time sources - good for PDCs on Windows Domains and Hyper-V hosts.
REM Author Oliver Caldwell; 28 August 2023.

REM Stop the W32Time service:
net stop w32time

REM Configure the external time sources. I like time.nist.gov but the pool.ntp.org project also a valid choice.
w32tm /config /syncfromflags:manual /manualpeerlist:time.nist.gov

REM Make your PDC a reliable time source for the clients:
w32tm /config /reliable:yes

REM Start the w32time service:
net start w32time

REM Wait ~1 minute and recheck that the config has stuck and the time has synced succesfully to the new source
w32tm /query /status

