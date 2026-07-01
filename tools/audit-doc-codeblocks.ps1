[CmdletBinding()]
param(
    [string]$Root = "."
)

$ErrorActionPreference = "Stop"
$Findings = New-Object System.Collections.Generic.List[object]

function Add-Finding {
    param($File,$Line,$Rule,$Message)
    $Findings.Add([PSCustomObject]@{File=$File;Line=$Line;Rule=$Rule;Message=$Message}) | Out-Null
}

$MarkdownFiles = Get-ChildItem -Path (Join-Path $Root "docs") -Recurse -Filter *.md
foreach ($File in $MarkdownFiles) {
    $Lines = Get-Content $File.FullName
    $InFence = $false
    $FenceLang = ""
    for ($i=0; $i -lt $Lines.Count; $i++) {
        $Line = $Lines[$i]
        if ($Line -match '^```') {
            if (-not $InFence) {
                $InFence = $true
                $FenceLang = ($Line -replace '^```','').Trim().ToLowerInvariant()
            }
            else {
                $InFence = $false
                $FenceLang = ""
            }
            continue
        }
        if (-not $InFence) { continue }
        $Rel = Resolve-Path -Path $File.FullName -Relative
        if ($FenceLang -match 'powershell|ps1') {
            if ($Line -match "-match '\\\(.*\)\$'") { Add-Finding $Rel ($i+1) "PS001" "Fragile escaped group regex in permission validation. Use short-name group validation." }
            if ($Line -match "SamAccountName\s+-in") { Add-Finding $Rel ($i+1) "PS002" "Invalid AD -Filter style using -in. Use LDAPFilter foreach or filter all then Where-Object." }
            if ($Line -match "Get-ADOrganizationalUnit\s+.*-Identity") { Add-Finding $Rel ($i+1) "PS003" "Do not use Get-ADOrganizationalUnit -Identity for existence checks. Use Get-ADObject or LDAPFilter." }
            if ($Line -match "Get-ADGroup\s+-Filter\s+'Name\s+-in") { Add-Finding $Rel ($i+1) "PS004" "Invalid Get-ADGroup -Filter -in pattern." }
        }
        if ($FenceLang -match 'routeros') {
            if ($Line -match 'discover-interface-list=MGMT|allowed-interface-list=MGMT') {
                # Require the same code fence to include interface list creation before management restriction.
                $Previous = ($Lines[0..$i] -join "`n")
                if ($Previous -notmatch '/interface/list/add name=MGMT' -and $Previous -notmatch '/interface list add name=MGMT') { Add-Finding $Rel ($i+1) "ROS001" "MGMT interface list is referenced before creation earlier in the document." }
            }
        }
    }
}

if ($Findings.Count -gt 0) {
    $Findings | Format-Table File,Line,Rule,Message -Wrap
    throw "GEIL code block audit failed with $($Findings.Count) finding(s)."
}

Write-Host "GEIL code block audit passed. No known bad code patterns found." -ForegroundColor Green
