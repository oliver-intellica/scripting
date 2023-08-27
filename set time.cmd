`Stop the W32Time service:
net stop w32time

`Configure the external time sources, type:
w32tm /config /syncfromflags:manual /manualpeerlist:time.nist.gov

`Make your PDC a reliable time source for the clients:
w32tm /config /reliable:yes

`Start the w32time service:
net start w32time
