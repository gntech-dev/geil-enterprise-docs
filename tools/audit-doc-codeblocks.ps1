<#
.SYNOPSIS
Audits GEIL Markdown code blocks for execution-correctness failure patterns.

.DESCRIPTION
This PowerShell implementation mirrors the repository DQI gate used by tools/audit-doc-codeblocks.sh.
It is intended for Windows/PowerShell reviewers and CI runners that prefer PowerShell.
The audit fails with a non-zero exit code when any finding is detected.
#>
[CmdletBinding()]
param(
    [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
)

$ErrorActionPreference = 'Stop'
$Docs = Join-Path $Root 'docs'
$Findings = New-Object System.Collections.Generic.List[object]

function Add-Finding {
    param(
        [string]$File,
        [int]$Line,
        [string]$Code,
        [string]$Message
    )
    $Findings.Add([pscustomobject]@{ File = $File; Line = $Line; Code = $Code; Message = $Message })
}

function Get-LineNumber {
    param([string]$Text, [int]$Index)
    if ($Index -le 0) { return 1 }
    return (($Text.Substring(0, $Index) -split "`n").Count)
}

function Test-ImplementationGuide {
    param([string]$RelativePath, [string]$Text)
    $lower = $RelativePath.ToLowerInvariant()
    if ($lower -match '^(governance|project|architecture)/' -or $lower.EndsWith('/index.md') -or $lower.EndsWith('-lld.md') -or $lower.EndsWith('powershell-operations.md')) { return $false }
    if ($Text.Contains('## Step-by-Step Procedure') -or $Text.Contains('## Deployment Validation')) { return $true }
    return $lower -match 'implementation|baseline|foundation|runbook|golden-template|nps-radius|ad-cs-pki|windows-admin-center|entra|intune|hello|defender|backup|monitoring|security-operations'
}

function Test-ActiveOpnsenseReference {
    param([string]$RelativePath, [string]$Line)
    $lowerPath = $RelativePath.ToLowerInvariant()
    $lowerLine = $Line.ToLowerInvariant()
    if ($lowerPath.Contains('opnsense')) { return $false }
    foreach ($word in @('superseded','historical','adr-0002','replaced','do not use','not active','no active','obsolete','alternative','drift')) {
        if ($lowerLine.Contains($word)) { return $false }
    }
    if ($lowerLine.Contains('mikrotik') -and $lowerLine.Contains('opnsense')) { return $false }
    return $true
}

$RequiredSections = @('Goal','Why','Prerequisites','Starting state','Commands','Validation','Expected','Rollback','Evidence','Next')
$MarkdownFiles = Get-ChildItem -Path $Docs -Recurse -Filter '*.md' | Sort-Object FullName

foreach ($File in $MarkdownFiles) {
    $Text = Get-Content -Path $File.FullName -Raw -Encoding UTF8
    $Relative = [System.IO.Path]::GetRelativePath($Root, $File.FullName).Replace('\\','/')
    $DocRelative = [System.IO.Path]::GetRelativePath($Docs, $File.FullName).Replace('\\','/')

    if (Test-ImplementationGuide -RelativePath $DocRelative -Text $Text) {
        if (-not $Text.Contains('## Deployment Verified')) {
            Add-Finding -File $Relative -Line 1 -Code 'DQI001' -Message "Implementation guide is missing mandatory 'Deployment Verified' section."
        }
    }

    $Lines = $Text -split "`n"
    for ($i = 0; $i -lt $Lines.Count; $i++) {
        $Line = $Lines[$i]
        if ($Line.Contains('OPNsense') -and (Test-ActiveOpnsenseReference -RelativePath $DocRelative -Line $Line)) {
            Add-Finding -File $Relative -Line ($i + 1) -Code 'ENV001' -Message 'Potential active obsolete OPNsense deployment reference; active Phase 1 must use MikroTik CHR unless explicitly superseded/historical.'
        }
        if ($Line -match '\b10\.10\.\d+\.\d+\b' -and $Line -notmatch '(?i)existing|non-GEIL|do not') {
            Add-Finding -File $Relative -Line ($i + 1) -Code 'ENV002' -Message 'Legacy 10.10.x.x enterprise reference without explicit non-GEIL/historical context.'
        }
        if ($Line -match '-match\s+[''\"]([^''\"]+)[''\"]') {
            try { [regex]::new(($Matches[1] -replace '\\\\','\')) | Out-Null } catch { Add-Finding -File $Relative -Line ($i + 1) -Code 'PS001' -Message "Invalid PowerShell regex literal '$($Matches[1])': $($_.Exception.Message)" }
        }
    }

    if ($Text -match 'Get-AD\w+\s+-Filter\s+[''\"][^''\"\n]*\s-in\s') {
        Add-Finding -File $Relative -Line 1 -Code 'AD001' -Message 'Invalid AD -Filter expression uses PowerShell-style -in. Use LDAPFilter loop or valid AD filter syntax.'
    }
    if ($Text -match 'Get-ADOrganizationalUnit\s+-Identity\s+\$') {
        Add-Finding -File $Relative -Line 1 -Code 'AD002' -Message 'Potential OU existence check with Get-ADOrganizationalUnit -Identity. Use parent validation plus LDAPFilter/OneLevel for missing OUs.'
    }
    if ($Text.Contains('VLAN30-Workstations')) {
        Add-Finding -File $Relative -Line 1 -Code 'NAME001' -Message 'Potential DHCP scope name mismatch: use canonical WORKSTATIONS-HQ.'
    }
    if ($Text -match '```powershell[\s\S]*?```\s*else\b') {
        Add-Finding -File $Relative -Line 1 -Code 'PS003' -Message 'Fragmented interactive PowerShell if/else block; publish a complete executable block.'
    }
}

if ($Findings.Count -gt 0) {
    'GEIL documentation code-block audit FAILED'
    foreach ($Finding in $Findings) {
        '{0}:{1} [{2}] {3}' -f $Finding.File, $Finding.Line, $Finding.Code, $Finding.Message
    }
    @{ finding_count = $Findings.Count } | ConvertTo-Json
    exit 1
}

@{
    status = 'PASS'
    markdown_files_audited = $MarkdownFiles.Count
    finding_count = 0
} | ConvertTo-Json -Depth 3
