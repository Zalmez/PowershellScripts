Function runScriptFromServer()
{
    [string]$ScriptParentFolder = "M:\pc\Dokumenter\GitHub\PowershellScripts\" #Hoved mappe(aka ParentFolder)
    [string]$ScriptName = "test_Script.ps1"#Array ved bruk av flere script navn
    [string]$LogFile = "M:\Documents\logfiles\logfile.log"
    [string]$LogActionFile = "C:\ScriptLogs\Action"

    $testGivenPath = Test-Path -path $ScriptParentFolder

    if($testGivenPath -eq $true )
    {
        
        Write-Output  "Path: '$($ScriptParentFolder)'  exists!"
        $allChildren = Get-ChildItem -path $PATH -Recurse -Directory | Select-Object Name
        
        foreach($children in $allChildren)
        {
            #Write-Output bruker jeg hovedsakelig for debugging og testing
            #Write-Output "============================================="
            #Write-Output "Child Name: " + $children
            #Write-Output "============================================="
            $ScriptPath = $ScriptParentFolder + $children.Name
            #Write-Output "Script Path: " + $ScriptPath
            $FullPath =  $ScriptPath + "\" + $ScriptName
            #Write-Output "============================================="
            #Write-Output "Full Script path: " + $FullPath
            Invoke-Expression $FullPath -Verbose
            Add-Content $LogFile -Value $FullPath
        }

    }else{Write-Output "The Path: '$($PATH)' does not exist"}
}

runScriptFromServer