Function runScriptFromServer() {
    [string]$ScriptParentFolder = "M:\pc\Dokumenter\GitHub\PowershellScripts\" #Hoved mappe(aka ParentFolder)
    [string]$ScriptName = "test_Script.ps1"
    [string]$LogFile = "C:\logs\testLog.txt"
    [string]$LogActionFile = "C:\ScriptLogs\ActionLog.txt"
    $confirmedPaths = New-Object 'System.Collections.Generic.HashSet[string]'
    $testGivenPath = doesPathExist($ScriptParentFolder)
    
    $doesLogFileExist = doesPathExist($LogFile)
    
    #clearHashValues($confirmedPaths)

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
            write-Output "Full Script path: " $FullPath
            if (doesPathExist($FullPath) -eq $true) {
                $confirmedPaths.Add($FullPath)
            }
        }
        #Write-Output "========================================"
        #Write-Output $confirmedPaths

        if($hasScriptRunned.Length -eq 0){
            Write-Output "Log is empty"
            for ($i = 0; $i -lt $confirmedPaths.Count; $i++) {
                #$confirmedPaths.GetEnumerator() | Sort-Object -Descending
                Write-Output "===================getting type==================="
                Write-Output $confirmedPaths | ForEach-Object {$_.Key}
                #Add-Content $LogFile -Value $confirmedPaths[$i]
            }
        }else{
            for ($i = 0; $i -lt $confirmedPaths.Count; $i++) {
                foreach($line in $hasScriptRunned){
                    if($confirmedPaths.Contains($line)){
                        break;
                    }else{
                        #Write-Output $confirmedPaths | ForEach-Object {$_.Key}
                        #Invoke-Expression $confirmedPaths[$i]

                        #debugging
                        #Write-Output "Logging and script running disabled"
                        #print all objects
                        #$confirmedPaths.GetEnumerator() | Sort-Object -Descending
                        #Add to logs
                        #Add-Content $LogFile -Value $confirmedPaths.GetEnumerator()
                    }
                }
            }
        }


    }
    
    else {Write-Output "The Path: '$($PATH)' does not exist"}
}

function clearLogFile($targetFile){
    Clear-Content -Path $targetFile
}

function clearHashValues($targetHashset){
    $targetHashset = New-Object 'System.Collections.Generic.HashSet[string]'
    $targetHashset.Clear()
}

function doesPathExist ([string]$pathToTest) {
    Test-Path -Path $pathToTest
}

#Run the function
runScriptFromServer

# {} | $