# Set the computer name to monitor
$ComputerName = "SERVER01"

# Monitor CPU usage
$CPUThreshold = 80 # Percentage
$CPULoad = (Get-WmiObject -ComputerName $ComputerName Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average
if ($CPULoad -ge $CPUThreshold) {
    Write-Host "High CPU usage detected on $ComputerName. Current usage: $CPULoad%"
}

# Monitor Memory usage
$MemoryThreshold = 80 # Percentage
$MemoryUsage = Get-WmiObject -ComputerName $ComputerName Win32_OperatingSystem | Select-Object @{Label = "MemoryUsage"; Expression = {($_.TotalVisibleMemorySize - $_.FreePhysicalMemory) / $_.TotalVisibleMemorySize * 100}}
if ($MemoryUsage.MemoryUsage -ge $MemoryThreshold) {
    Write-Host "High memory usage detected on $ComputerName. Current usage: $($MemoryUsage.MemoryUsage)%"
}

# Monitor Disk usage
$DiskThreshold = 80 # Percentage
$Disks = Get-WmiObject -ComputerName $ComputerName Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID, @{Name = "FreeSpaceGB"; Expression = {($_.FreeSpace / 1GB)}}, @{Name = "SizeGB"; Expression = {($_.Size / 1GB)}}
foreach ($Disk in $Disks) {
    $DiskUsage = (($Disk.SizeGB - $Disk.FreeSpaceGB) / $Disk.SizeGB) * 100
    if ($DiskUsage -ge $DiskThreshold) {
        Write-Host "High disk usage detected on $ComputerName. Drive $($Disk.DeviceID) is at $($DiskUsage)% capacity."
    }
}

# Troubleshoot Network Issues
$PingThreshold = 100 # Milliseconds
$PingResult = Test-Connection -ComputerName $ComputerName -Count 1
if ($PingResult.ResponseTime -ge $PingThreshold) {
    Write-Host "High network latency detected on $ComputerName. Average response time: $($PingResult.ResponseTime)ms."
}
