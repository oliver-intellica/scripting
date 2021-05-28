$ip = "192.168.100.10"
$prefix = "24"
$GW = "192.168.100.1"
$DNS = "192.168.100.10"
$adapter = (Get-NetAdapter).ifIndex
New-NetIPAddress -IPAddress $ip -PrefixLength $prefix `
-InterfaceIndex $adapter -DefaultGateway $GW