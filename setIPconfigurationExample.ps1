#set IP settig for interface $adapter
$ip = "192.168.100.10"
$prefix = "24"
$GW = "192.168.100.1"
$adapter = (Get-NetAdapter).ifIndex #won't work with multiple adapters...
New-NetIPAddress -IPAddress $ip -PrefixLength $prefix `
-InterfaceIndex $adapter -DefaultGateway $GW

#set DNS for interface 12 < find this value with Get-NetAdapter
$DNS1 = "192.168.100.10"
$DNS2 = "192.168.100.11"
Set-DnsClientServerAddress -InterfaceIndex 12 -ServerAddresses ($DNS1,$DNS2)