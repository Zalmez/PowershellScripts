Function runScriptFromServer() {
    [string]$ScriptParentFolder = "C:\Test\" #Hoved mappe(aka ParentFolder)
    [string]$ScriptName = "test_Script.ps1"
    [string]$LogFile = "C:\logs\testLog.txt"
    [string]$LogActionFile = "C:\ScriptLogs\ActionLog.txt"
    $testGivenPath = testPath($ScriptParentFolder)
    
    $doesLogFileExist = testPath($LogFile)

    # Noen av disse variabelnavnene er litt forvirrende. Denne burde kanskje hete $logFileContents eller noe sånt (for meg ser det ut som at det burde være en boolean)
    $hasScriptRunned = Get-Content $LogFile

    if ($doesLogFileExist -eq $false) {
        New-Item -Path $LogFile -Type File -Force
    }

    if ($testGivenPath -eq $true ) {
        #Write-Output  "Path: '$($ScriptParentFolder)'  exists!"
        $allChildren = Get-ChildItem -path $ScriptParentFolder -Recurse -Directory | Select-Object Name        
            
        # Her er hoveddelen av skriptet ditt. Du vil gå gjennom alle mappene ($children) ...
        foreach ($children in $allChildren) {           
            $hasCurrentScriptRan = $false
            $ScriptPath = $ScriptParentFolder + $children.Name
            $FullPath = $ScriptPath + "\" + $ScriptName
            write-Output "Full Script path: " + $FullPath
            # ... sjekke om skriptet faktisk finnes ...
            if (testPath($FullPath) -eq $true) {                                
                # Gå gjennom hver linje i loggfila (merk at du ikke trenger å ta spesiell høyde for at fila ikke inneholder noen linjer -- det betyr bare at denne løkka ikke kjører)
                foreach ($line in $hasScriptRunned) {                        
                    if ($FullPath -eq $line) {                            
                        # Hvis vi finner en linje som matcher navnet på skriptet så har det blitt kjørt fra før. Sett et flagg og stopp.
                        $hasCurrentScriptRan = $true                        
                        break
                    } 
                }                

                # Når vi har gått gjennom alle linjene kan vi se om flagget har blitt satt, hvis ikke kjører vi skriptet.
                if (! $hasCurrentScriptRan) { # (! $hasCurrentScriptRan) tilsvarer ($hasCurrentScriptRan -eq $false)
                    Invoke-Expression $FullPath
                    Add-Content $LogFile -Value $FullPath
                }
            } else {
                Write-Output "Ignoring folder. Script not found"
            }        
        }    
    } else {
        Write-Output "The Path: '$($PATH)' does not exist"
    }
}

function readLogFile() {
    $ReadLogFile = Get-Content -Path $LogFile

    foreach ($line in $ReadLogFile) {
        Write-Output $line
    }

}

function testPath ([string]$pathToTest) {
    Test-Path -Path $pathToTest
}

runScriptFromServer
#readLogFile