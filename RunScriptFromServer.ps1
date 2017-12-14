Function runScriptFromServer() {
    [string]$ScriptParentFolder = "M:\pc\Dokumenter\GitHub\PowershellScripts" #Hoved mappe(aka ParentFolder)
    [string]$ScriptName = "test_script.ps1"
    [string]$LogFile = "C:\logs\testLog.txt"
    [string]$LogActionFile = "C:\logs\ActionLog.txt"
    $testGivenPath = testPath($ScriptParentFolder)

    $doesActionLogFileExist = testPath($LogActionFile)
    $doesLogFileExist = testPath($LogFile)

    # Noen av disse variabelnavnene er litt forvirrende. Denne burde kanskje hete $logFileContents eller noe sånt (for meg ser det ut som at det burde være en boolean)
    
    if($doesActionLogFileExist -eq $false){
        New-Item -Path $LogActionFile -Type File -Force
        writeAction("Action file did not exist, created Action Log File")
    }
    
    if ($doesLogFileExist -eq $false) {
        New-Item -Path $LogFile -Type File -Force
        writeAction("Log file does not exist! Created Log File")
    }

    $logFileContents = Get-Content $LogFile

    if ($testGivenPath -eq $true ) {
        #Write-Output  "Path: '$($ScriptParentFolder)'  exists!"
        $allChildren = Get-ChildItem -path $ScriptParentFolder -Recurse -Directory | Select-Object Name        
            
        # Her er hoveddelen av skriptet ditt. Du vil gå gjennom alle mappene ($children) ...
        foreach ($children in $allChildren) {           
            $hasCurrentScriptRan = $false
            $ScriptPath = $ScriptParentFolder + $children.Name
            $FullPath = $ScriptPath + "\" + $ScriptName
            #write-Output "Full Script path: " + $FullPath
            # ... sjekke om skriptet faktisk finnes ...
            if (testPath($FullPath) -eq $true) {                                
                # Gå gjennom hver linje i loggfila (merk at du ikke trenger å ta spesiell høyde for at fila ikke inneholder noen linjer -- det betyr bare at denne løkka ikke kjører)
                foreach ($line in $logFileContents) {                        
                    if ($FullPath -eq $line) {                            
                        # Hvis vi finner en linje som matcher navnet på skriptet så har det blitt kjørt fra før. Sett et flagg og stopp.
                        $hasCurrentScriptRan = $true                        
                        break
                    } 
                }                

                # Når vi har gått gjennom alle linjene kan vi se om flagget har blitt satt, hvis ikke kjører vi skriptet.
                if (! $hasCurrentScriptRan) { # (! $hasCurrentScriptRan) tilsvarer ($hasCurrentScriptRan -eq $false)
                    Invoke-Expression $FullPath
                    writeLog($FullPath)
                }
            } #else {
               # writeAction("Script not found. Ignoring folder")
            #}        
        }    
    } else {
        writeAction("The Path: '$($PATH)' does not exist")
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

function writeAction($strValue){
    [string]$LogActionFile = "C:\logs\ActionLog.txt"
    $Date = Get-Date
    Add-Content -Path $LogActionFile -Value "[($Date)]: ($strValue)"
}

function writeLog($strValue){
    [string]$LogFile = "C:\logs\testLog.txt"
    Add-Content -Path $LogFile -Value "($strValue)"
}

runScriptFromServer
#readLogFile