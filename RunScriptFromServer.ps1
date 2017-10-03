Function runScriptFromServer() {
    [string]$ScriptParentFolder = "M:\pc\Dokumenter\GitHub\PowershellScripts\" #Hoved mappe(aka ParentFolder)
    [string]$ScriptName = "test_script.ps1"
    [string]$LogFile = "C:\logs\testLog.txt"
    [string]$LogActionFile = "C:\ScriptLogs\ActionLog.txt"
    $confirmedPaths = New-Object "System.Collections.ArrayList"
    $testGivenPath = testPath($ScriptParentFolder)
    
    $doesLogFileExist = testPath($LogFile)

    $hasScriptRunned = Get-Content $LogFile 

    if ($doesLogFileExist -eq $false) {
        New-Item -Path $LogFile -Type File -Force
    }

    if ($testGivenPath -eq $true ) {
        #print("Path: '$($ScriptParentFolder)'  exists!")
        $allChildren = Get-ChildItem -path $PATH -Recurse -Directory | Select-Object Name
            
        foreach ($children in $allChildren) {
            $ScriptPath = $ScriptParentFolder + $children.Name
            $FullPath = $ScriptPath + "\" + $ScriptName
            #print("Full Script path: " + $FullPath)
            if (testPath($FullPath) -eq $true) {
                if ($hasScriptRunned.Length -eq 0) {
                    print("Log is empty")
                    Invoke-Expression $FullPath
                    Add-Content $LogFile -Value $FullPath
                }
                else {
                    $confirmedPaths.Add($FullPath)
                }
            }
            else {Write-Output "Ignoring folder. Script not found"}
        
        }
        #print($newPath)
        if($hasScriptRunned.Length -ne 0){
            for ($i = 0; $i -lt $confirmedPaths.Count; $i++) {
                for ($x = 0; $x -lt $hasScriptRunned.Count; $x++) {
                    if ($confirmedPaths[$i] -ne $hasScriptRunned[$x]) {
                        Invoke-Expression $confirmedPaths[$i]
                        Add-Content -Path $LogFile -Value $confirmedPaths[$i]
                    }else{
                        print("Script exists in logs")
                    }
                }
        }
            # foreach($line in $hasScriptRunned){
            #     if($confirmedPaths[$i] -ne $line){
            #         #print($confirmedPaths[$i])
            #         Invoke-Expression $confirmedPaths[$i]
            #     }else{
            #         break;
            #     }
        }
        #else {print("The Path: '$($PATH)' does not exist")}
    }
}

#laget for debugging
function readLogFile() {
    $ReadLogFile = Get-Content -Path "C:\logs\testLog.txt"

    foreach ($line in $ReadLogFile) {
        print($line)
    }

}

function testPath ([string]$pathToTest) {
    Test-Path -Path $pathToTest
}

function print ([string]$textToPrint) {
    Write-Output $textToPrint
}

runScriptFromServer
#readLogFile