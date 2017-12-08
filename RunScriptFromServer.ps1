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
                if (readLogFile($FullPath) -eq $false -and -ne $null) {
                    #Invoke-Expression $FullPath
                    Add-Content $LogFile $FullPath        
                }
                else {
                    printDebug("Path exists in logs")
                }
            }
            else {Write-Output "Ignoring folder. Script not found"}
        
        }
    }
}

#laget for debugging
function readLogFile($pathToControll) {
    $LogContent = Get-Content -Path "C:\logs\testLog.txt"
    $amountOfLines = 0
    $isLineEqual #( = Set-Variable -Visibility global -Value $false) Har ikke prøvd å gjøre den global kan hjelpe
    if ($LogContent -eq $null) {
        printDebug("There's no content in the log file")
        $isLineEqual = $false
    }
    foreach ($line in $LogContent) {
        $amountOfLines = $amountOfLines + 1
        print($amountOfLines)
        print("Path from log: " + $line)
        printDebug("Controlled Path: " + $pathToControll)

        if ($pathToControll -ne $line) {
            $isLineEqual = $False 
            
        }
        else {
            $isLineEqual = $True
            break
        }
        printDebug($isLineEqual)
    }
    return $isLineEqual

}

function testPath ([string]$pathToTest) {
    Test-Path -Path $pathToTest
}

function print ([string]$textToPrint) {
    Write-Output $textToPrint
}

function printDebug($textToPrint) {
    Write-Debug $textToPrint
}

#readLogFile
runScriptFromServer