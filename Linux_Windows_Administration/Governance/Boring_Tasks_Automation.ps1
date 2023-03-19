# Define a function to perform the administrative tasks
function Perform-AdminTasks {
    # Task 1: Get a list of running processes and their memory usage
    Get-Process | Select-Object Name,Id,WorkingSet | Sort-Object WorkingSet -Descending | Format-Table -AutoSize

    # Task 2: Get a list of installed software
    Get-WmiObject -Class Win32_Product | Select-Object Name,Version,Vendor | Sort-Object Name | Format-Table -AutoSize

    # Task 3: Get a list of local user accounts
    Get-LocalUser | Select-Object Name,Description,Enabled | Sort-Object Name | Format-Table -AutoSize
}

# Run the administrative tasks every 24 hours
while ($true) {
    Perform-AdminTasks
    Start-Sleep -Seconds 86400  # 24 hours = 86400 seconds
}
