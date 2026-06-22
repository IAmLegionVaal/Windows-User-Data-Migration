<#
.SYNOPSIS
Plans and optionally copies common Windows user-data folders.
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [string]$SourceProfile=[Environment]::GetFolderPath('UserProfile'),
    [Parameter(Mandatory=$true)][string]$Destination,
    [switch]$Copy,
    [string[]]$Folder=@('Desktop','Documents','Downloads','Pictures','Music','Videos','Favorites'),
    [string]$LogRoot="$env:ProgramData\WindowsUserDataMigration\Logs"
)

Set-StrictMode -Version 2.0
$ErrorActionPreference='Stop'
$stamp=Get-Date -Format 'yyyyMMdd_HHmmss'
$runPath=Join-Path $LogRoot $stamp
$targetRoot=Join-Path $Destination (Split-Path $SourceProfile -Leaf)
$results=New-Object System.Collections.Generic.List[object]
$failed=New-Object System.Collections.Generic.List[object]

try{
    if($env:OS -ne 'Windows_NT'){throw 'Windows is required.'}
    if(-not(Test-Path $SourceProfile)){throw "Source profile not found: $SourceProfile"}
    New-Item $runPath -ItemType Directory -Force|Out-Null

    foreach($name in $Folder){
        $source=Join-Path $SourceProfile $name
        $target=Join-Path $targetRoot $name
        if(-not(Test-Path $source)){
            $results.Add([pscustomobject]@{Folder=$name;Source=$source;Target=$target;Exists=$false;Files=0;Bytes=0;Copied=$false})
            continue
        }

        $items=Get-ChildItem $source -File -Recurse -ErrorAction SilentlyContinue
        $count=@($items).Count
        $bytes=($items|Measure-Object Length -Sum).Sum
        if($null -eq $bytes){$bytes=0}
        $copied=$false

        if($Copy -and $PSCmdlet.ShouldProcess($target,"Copy data from $source")){
            New-Item $target -ItemType Directory -Force|Out-Null
            $log=Join-Path $runPath ("Robocopy_{0}.txt" -f $name)
            robocopy.exe $source $target /E /COPY:DAT /DCOPY:DAT /R:2 /W:2 /XJ /FFT /NP /TEE /LOG:$log
            $code=$LASTEXITCODE
            if($code -le 7){$copied=$true}else{$failed.Add([pscustomobject]@{Folder=$name;ExitCode=$code;Log=$log})}
        }

        $results.Add([pscustomobject]@{Folder=$name;Source=$source;Target=$target;Exists=$true;Files=$count;Bytes=$bytes;Copied=$copied})
    }

    $results|Export-Csv (Join-Path $runPath 'MigrationPlan.csv') -NoTypeInformation
    $failed|Export-Csv (Join-Path $runPath 'Failures.csv') -NoTypeInformation
    'This tool intentionally excludes AppData, browser profiles, credential stores and encryption keys.'|
        Out-File (Join-Path $runPath 'ScopeNotice.txt')

    Write-Host "[OK] Completed. Plan: $runPath" -ForegroundColor Green
    if($Copy){Write-Host "Destination: $targetRoot" -ForegroundColor Green}
    if($failed.Count -gt 0){exit 2}else{exit 0}
}catch{Write-Error $_.Exception.Message;exit 1}
