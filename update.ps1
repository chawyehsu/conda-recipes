param(
    [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
    [string[]]$Package
)

$ErrorActionPreference = 'Stop'

if (-not (Get-Command -Name ConvertFrom-Yaml -ErrorAction SilentlyContinue)) {
    Write-Error "ConvertFrom-Yaml is required. Please run with PowerShell 7.2+"
    exit 1
}

$root = Split-Path -Parent $MyInvocation.MyCommand.Path

function Get-TargetPackages {
    param(
        [string]$RootPath,
        [string[]]$Names
    )

    $targets = @()
    if ($Names -and $Names.Count -gt 0) {
        foreach ($name in $Names) {
            $dir = Join-Path $RootPath $name
            if (-not (Test-Path -LiteralPath $dir -PathType Container)) {
                continue
            }
            $recipe = Join-Path $dir 'recipe.yaml'
            if (Test-Path -LiteralPath $recipe -PathType Leaf) {
                $targets += $dir
            }
        }
        return $targets
    }

    Get-ChildItem -LiteralPath $RootPath -Directory | Where-Object {
        $_.Name -ne 'output' -and -not $_.Name.StartsWith('.')
    } | ForEach-Object {
        $recipe = Join-Path $_.FullName 'recipe.yaml'
        if (Test-Path -LiteralPath $recipe -PathType Leaf) {
            $targets += $_.FullName
        }
    }

    return $targets
}

function Get-ReleaseInfo {
    param(
        [string]$Url
    )

    $match = [regex]::Match($Url, '^https?://github\.com/(?<owner>[^/]+)/(?<repo>[^/]+)/')
    if (-not $match.Success) {
        return $null
    }

    if ($Url -notmatch '/(releases/download|archive/refs/tags|refs/tags)/') {
        return $null
    }

    return [pscustomobject]@{
        Owner = $match.Groups['owner'].Value
        Repo  = $match.Groups['repo'].Value
    }
}

function Normalize-VersionText {
    param(
        [string]$Value
    )

    if (-not $Value) {
        return $null
    }

    return ($Value.Trim() -replace '^[vV]', '')
}

function Parse-SemanticVersion {
    param(
        [string]$Value
    )

    $normalized = Normalize-VersionText $Value
    if (-not $normalized) {
        return $null
    }

    try {
        return [System.Management.Automation.SemanticVersion]::Parse($normalized)
    } catch {
        return $null
    }
}

function Resolve-SourceUrl {
    param(
        [string]$Url,
        [string]$CurrentVersion,
        [string]$LatestVersion
    )

    $resolved = $Url
    if ($resolved -match '\$\{\{\s*version\s*\}\}') {
        $resolved = $resolved -replace '\$\{\{\s*version\s*\}\}', $LatestVersion
    } else {
        $currentNormalized = Normalize-VersionText $CurrentVersion
        $escapedCurrent = [regex]::Escape($currentNormalized)
        $resolved = $resolved -replace "v$escapedCurrent", "v$LatestVersion"
        $resolved = $resolved -replace $escapedCurrent, $LatestVersion
    }

    if ($resolved -eq $Url) {
        return $null
    }

    return $resolved
}

function Update-Recipe {
    param(
        [string]$RecipePath,
        [string]$NewVersion,
        [string]$NewSha
    )

    $content = Get-Content -Raw -LiteralPath $RecipePath
    $versionPattern = '(?ms)(^context:\s*\r?\n(?:[^\S\r\n].*\r?\n)*?\s*version:\s*)(["'']?)([^"''\r\n]+)(\2)'
    $shaPattern = '(?ms)(^source:\s*\r?\n(?:[^\S\r\n].*\r?\n)*?\s*sha256:\s*)(["'']?)([^"''\r\n]+)(\2)'

    if (-not ([regex]::IsMatch($content, $versionPattern))) {
        Write-Output "  - skip: context.version not found"
        return $false
    }
    if (-not ([regex]::IsMatch($content, $shaPattern))) {
        Write-Output "  - skip: source.sha256 not found"
        return $false
    }

    $updated = [regex]::Replace($content, $versionPattern, {
        param($m)
        $m.Groups[1].Value + $m.Groups[2].Value + $NewVersion + $m.Groups[2].Value
    }, 1)

    $updated = [regex]::Replace($updated, $shaPattern, {
        param($m)
        $m.Groups[1].Value + $m.Groups[2].Value + $NewSha + $m.Groups[2].Value
    }, 1)

    if ($updated -ne $content) {
        [System.IO.File]::WriteAllText($RecipePath, $updated, [System.Text.UTF8Encoding]::new($false))
        return $true
    }

    return $false
}

$targets = Get-TargetPackages -RootPath $root -Names $Package
if (-not $targets -or $targets.Count -eq 0) {
    Write-Output 'No recipes found to update.'
    exit 0
}

foreach ($dir in $targets) {
    $name = Split-Path -Leaf $dir
    $recipePath = Join-Path $dir 'recipe.yaml'
    Write-Output "Checking $name"

    $content = Get-Content -Raw -LiteralPath $recipePath
    $data = ConvertFrom-Yaml $content

    if (-not $data.context -or -not $data.context.version) {
        Write-Output "  - skip: context.version missing"
        continue
    }

    $source = $data.source
    if (-not $source) {
        Write-Output "  - skip: source missing"
        continue
    }

    if ($source -is [array]) {
        Write-Output "  - skip: multiple sources"
        continue
    }

    $sourceUrl = $source.url
    if (-not $sourceUrl) {
        Write-Output "  - skip: source.url missing"
        continue
    }

    if ($sourceUrl -is [array]) {
        Write-Output "  - skip: multiple source.url entries"
        continue
    }

    $releaseInfo = Get-ReleaseInfo -Url $sourceUrl
    if (-not $releaseInfo) {
        Write-Output "  - skip: source.url not a GitHub release tag"
        continue
    }

    $currentVersionText = Normalize-VersionText $data.context.version
    $currentVersion = Parse-SemanticVersion $data.context.version
    if (-not $currentVersion) {
        Write-Output "  - skip: unsupported version '$($data.context.version)'"
        continue
    }

    $apiUrl = "https://api.github.com/repos/$($releaseInfo.Owner)/$($releaseInfo.Repo)/releases/latest"
    try {
        $release = Invoke-RestMethod -Uri $apiUrl -Headers @{ 'User-Agent' = 'conda-recipes-update' } -ErrorAction Stop
    } catch {
        Write-Output "  - skip: GitHub API error"
        continue
    }

    if (-not $release.tag_name) {
        Write-Output "  - skip: latest release tag missing"
        continue
    }

    $latestVersionText = Normalize-VersionText $release.tag_name
    $latestVersion = Parse-SemanticVersion $release.tag_name
    if (-not $latestVersion) {
        Write-Output "  - skip: unsupported latest tag '$($release.tag_name)'"
        continue
    }

    if ($latestVersion -le $currentVersion) {
        Write-Output "  - up-to-date ($currentVersionText)"
        continue
    }

    $resolvedUrl = Resolve-SourceUrl -Url $sourceUrl -CurrentVersion $currentVersionText -LatestVersion $latestVersionText
    if (-not $resolvedUrl) {
        Write-Output "  - skip: unable to resolve download URL"
        continue
    }

    $tempFile = [System.IO.Path]::GetTempFileName()
    try {
        Invoke-WebRequest -Uri $resolvedUrl -OutFile $tempFile -ErrorAction Stop
        $newSha = (Get-FileHash -Algorithm SHA256 -LiteralPath $tempFile).Hash.ToLowerInvariant()
    } catch {
        Write-Output "  - skip: failed to download or hash"
        Remove-Item -LiteralPath $tempFile -ErrorAction SilentlyContinue
        continue
    }

    Remove-Item -LiteralPath $tempFile -ErrorAction SilentlyContinue

    if (Update-Recipe -RecipePath $recipePath -NewVersion $latestVersionText -NewSha $newSha) {
        Write-Output "  - updated to $latestVersionText"
    } else {
        Write-Output "  - skip: failed to update recipe"
    }
}
