Function runScriptFromServer() {
    [string]$ScriptParentFolder = "M:\pc\Dokumenter\GitHub\PowershellScripts\" #Hoved mappe(aka ParentFolder)
    [string]$ScriptName = "test_Script.ps1"
    [string]$LogFile = "C:\logs\testLog.txt"
    [string]$LogActionFile = "C:\ScriptLogs\ActionLog.txt"

    $testGivenPath = Test-Path -path $ScriptParentFolder
    
    $doesLogFileExist = Test-Path -Path $LogFile 

    if ($doesLogFileExist -eq $false) {
        New-Item -Path $LogFile -Type File -Force
    }

    if ($testGivenPath -eq $true ) {
        Write-Output  "Path: '$($ScriptParentFolder)'  exists!"
        $allChildren = Get-ChildItem -path $PATH -Recurse -Directory | Select-Object Name
            
        foreach ($children in $allChildren) {
            $ScriptPath = $ScriptParentFolder + $children.Name
            $FullPath = $ScriptPath + "\" + $ScriptName
            Write-Output "Full Script path: " + $FullPath
            $hasScriptRunned = Get-Content $LogFile
            if ($hasScriptRunned.Length -eq 0) {
                Write-Output "Log is empty"
                Invoke-Expression $FullPath
                Add-Content $LogFile -Value $FullPath
            }
            else {
                foreach ($line in $hasScriptRunned) {
                    if ($line -ne $FullPath) {
                        Write-Output $FullPath
                        #Invoke-Expression $FullPath
                        #Add-Content $LogFile -Value $FullPath                        
                    }else{
                        Write-Output "Script is equal"
                    }
                }
            }
        }
    
    }
    else {Write-Output "The Path: '$($PATH)' does not exist"}
}

function readLogFile(){
    $ReadLogFile = Get-Content -Path "C:\logs\testLog.txt"

    foreach($line in $ReadLogFile){
        Write-Output $line
    }

}

runScriptFromServer
#readLogFile