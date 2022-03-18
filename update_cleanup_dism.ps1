# **NOTE: Server 2012 has limited availability of the below commands.
# You need to clean Component Store using command line tool called DISM. first, you need to analyze the store and then perform the cleanup
# Before doing cleanup make sure you have a good backup of host machine along with virtual machines or you can take fresh backup for a safer side.

dism.exe /online /Cleanup-Image /AnalyzeComponentStore
dism.exe /online /Cleanup-Image /StartComponentCleanup
dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
dism.exe /online /Cleanup-Image /SPSuperseded

