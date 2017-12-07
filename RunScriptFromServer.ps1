Function runScriptFromServer() {
    [string]$LogFile = "C:\logs\testLog.txt"
    [string]$ScriptParentFolder = "M:\pc\Dokumenter\GitHub\PowershellScripts\" #Hoved mappe(aka ParentFolder)
    [string]$ScriptName = "test_script.ps1"
    [string]$LogActionFile = "C:\ScriptLogs\ActionLog.txt"
    $testGivenPath = testPath($ScriptParentFolder)
    
    $doesLogFileExist = testPath($LogFile)

    #$logContent = Get-Content $LogFile 

    if ($doesLogFileExist -eq $false) {
        New-Item -Path $LogFile -Type File -Force
    }

    if ($testGivenPath -eq $true ) {
        $allChildren = Get-ChildItem -path $ScriptParentFolder -Recurse -Directory | Select-Object Name
        foreach ($children in $allChildren) {
            $ScriptPath = $ScriptParentFolder + $children.Name
            print($ScriptPath)
            $FullPath = $ScriptPath + "\" + $ScriptName
            #print("Full Script path: " + $FullPath)
            if (testPath($FullPath)) {
                if(readLogFile($FullPath) -eq $false){
                    print("Full Path: " + $FullPath)
                    Add-Content $LogFile $FullPath        
                }else{
                    print("Path exists in logs")
                }
            }else {Write-Output "Ignoring folder. Script not found"}
        
        }
    }
}

#laget for debugging
function readLogFile($pathToControll) {
    $pathToControll = "M:\pc\Dokumenter\GitHub\PowershellScripts\tests\test_script.ps1"
    $LogContent = Get-Content -Path "C:\logs\testLog.txt"
    $amountOfLines = 0
    if($LogContent -eq $null){
        print("There's no content in the log file")
        return $false
    }
    foreach ($line in $LogContent) {
        $amountOfLines = $amountOfLines + 1
        print($amountOfLines)
        print("Path from log: " + $line)
        if($pathToControll -eq $line){
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

#readLogFile
runScriptFromServer