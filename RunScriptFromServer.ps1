Function runScriptFromServer()
{
    [string]$ScriptParentFolder = "M:\pc\Dokumenter\GitHub\PowershellScripts\" #Hoved mappe(aka ParentFolder)
    [string]$ScriptName = "test_Script.ps1"#Array ved bruk av flere script navn
    [string]$LogFile = "C:\logs\testLog.txt"
    [string]$LogActionFile = "C:\ScriptLogs\ActionLog.txt"

    $testGivenPath = Test-Path -path $ScriptParentFolder

    $doesLogExist = Test-Path -path $LogFile
    
    $doesScriptExist = $false
    

    try
    {
        $doesLogExist
    }catch
    {
        $doesLogExist = false
        Write-Warning "Log File does not exist"
        Write-Verbose "Creating LogFile"
        New-item $LogFile -type File -Force
    }

    if($testGivenPath -eq $true )
    {
        
        Write-Output  "Path: '$($ScriptParentFolder)'  exists!"
        $allChildren = Get-ChildItem -path $PATH -Recurse -Directory | Select-Object Name
        
        foreach($children in $allChildren)
        {
            $ScriptPath = $ScriptParentFolder + $children.Name
            $FullPath =  $ScriptPath + "\" + $ScriptName
            #Write-Output "============================================="
            #Write-Output "Full Script path: " + $FullPath
            try
            {
                $doesScriptExist = Test-Path -Path $FullPath
                if($LogFile -eq $null){
                    Invoke-Expression $FullPath -Verbose
                    Add-Content $LogFile -Value $FullPath
                }else{
                    if($LogFile -ne $null){
                        $hasScriptRunned = Get-Content $LogFile
                        foreach($line in $hasScriptRunned){
                            if($line -ne $FullPath){
                                Invoke-Expression $FullPath
                                Add-Content $LogFile -Value $FullPath
                            }else{
                                Write-Verbose -Message "Script has already been runned"
                            }
                        }
                    }
                }
            }catch{
                $doesScriptExist = $false
                Write-Verbose "Script does not exist in: " + $ScriptPath   
            }
        }

    }else{Write-Output "The Path: '$($PATH)' does not exist"}
}

runScriptFromServer