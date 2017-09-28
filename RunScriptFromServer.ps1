Function runScriptFromServer() {
    [string]$ScriptParentFolder = "M:\pc\Dokumenter\GitHub\PowershellScripts\" #Hoved mappe(aka ParentFolder)
    [string]$ScriptName = "test_Script.ps1"
    [string]$LogFile = "C:\logs\testLog.txt"
    [string]$LogActionFile = "C:\ScriptLogs\ActionLog.txt"
    $testGivenPath = testPath($ScriptParentFolder)
    
    $doesLogFileExist = testPath($LogFile)

    $hasScriptRunned = Get-Content $LogFile

    if ($doesLogFileExist -eq $false) {
        New-Item -Path $LogFile -Type File -Force
    }

    if ($testGivenPath -eq $true ) {
        #Write-Output  "Path: '$($ScriptParentFolder)'  exists!"
        $allChildren = Get-ChildItem -path $PATH -Recurse -Directory | Select-Object Name
            
        foreach ($children in $allChildren) {
            $ScriptPath = $ScriptParentFolder + $children.Name
            $FullPath = $ScriptPath + "\" + $ScriptName
            write-Output "Full Script path: " + $FullPath
            if (testPath($FullPath) -eq $true) {
                if ($hasScriptRunned.Length -eq 0) {
                    Write-Output "Log is empty"
                    Invoke-Expression $FullPath
                    Add-Content $LogFile -Value $FullPath
                }
                else {
                    foreach ($line in $hasScriptRunned) {
                        if ($FullPath -ne $line) {
                            #Write-Output $FullPath
                            Invoke-Expression $FullPath
                            Add-Content $LogFile -Value $FullPath                        
                        }
                        else {
                            Write-Output "Script is equal"
                        }
                    }
                }
            }else{Write-Output "Ignoring folder. Script not found"}
        
        }    
    }
    else {Write-Output "The Path: '$($PATH)' does not exist"}
}

function readLogFile() {
    $ReadLogFile = Get-Content -Path "C:\logs\testLog.txt"

    foreach ($line in $ReadLogFile) {
        Write-Output $line
    }

}

function testPath ([string]$pathToTest) {
    Test-Path -Path $pathToTest
}

runScriptFromServer
#readLogFile