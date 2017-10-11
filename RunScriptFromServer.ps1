Function runScriptFromServer() {
    [string]$ScriptParentFolder = "M:\pc\Dokumenter\GitHub\PowershellScripts\" #Hoved mappe(aka ParentFolder)
    [string]$ScriptName = "test_script.ps1"
    [string]$LogFile = "C:\logs\testLog.txt"
    [string]$LogActionFile = "C:\ScriptLogs\ActionLog.txt"
    $confirmedPaths = New-Object "System.Collections.ArrayList"
    $testGivenPath = testPath($ScriptParentFolder)
    
    $doesLogFileExist = testPath($LogFile)

    $logContent = Get-Content $LogFile 

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
                print($FullPath)
                if (readLogFile($FullPath) -eq $false){
                    print("does not exist in log file")
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
    }
}

#laget for debugging
function readLogFile($pathToControll) {
    $ReadLogFile = Get-Content -Path "C:\logs\testLog.txt"
    
    foreach ($line in $ReadLogFile) {
        if($pathToControll -eq $line){
            print("path exisit in logs")
            return $true
        }else{
            return $false
        }
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