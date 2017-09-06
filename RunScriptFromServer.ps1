Function runScriptFromServer()
{
    [string]$ScriptParentFolder = "M:\minefiler\Powershell\" #Hoved mappe(aka ParentFolder)
    [string]$ScriptName = "test_script.ps1"#Array ved bruk av flere script navn
    
    $testGivenPath = Test-Path -path $ScriptParentFolder

    if($testGivenPath -eq $true )
    {
        
        Write-Output  "Path: '$($ScriptParentFolder)'  exists!"
        $allChildren = Get-ChildItem -path $PATH -Recurse -Directory | Select-Object Name
        
        foreach($children in $allChildren)
        {
            #Write-Output bruker jeg hovedsakelig for debugging og testing
            Write-Output "============================================="
            Write-Output "Child Name: " + $children
            Write-Output "============================================="
            $ScriptPath = $PATH + $children.Name
            Write-Output "Script Path: " + $ScriptPath
            Invoke-Expression $ScriptPath + "\" + $ScriptName
        }

    }else{Write-Output "The Path: '$($PATH)' does not exist"}
}

runScriptFromServer