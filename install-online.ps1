# Standalone installer: PowerShell 5.1+, no Git or Python required.
param([string]$SkillsDirectory)
$ErrorActionPreference = 'Stop'
$skillName = 'linkedin-content-writer'
if (-not $SkillsDirectory) {
    $codexDirectory = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME '.codex' }
    $SkillsDirectory = Join-Path $codexDirectory 'skills'
}
$skillsRoot = [IO.Path]::GetFullPath($SkillsDirectory)
$target = Join-Path $skillsRoot $skillName
if ((Test-Path -LiteralPath $target) -and ((Get-Item -LiteralPath $target).Attributes -band [IO.FileAttributes]::ReparsePoint)) {
    throw 'The destination is a link. Choose another skills directory.'
}
$null = New-Item -ItemType Directory -Force -Path $skillsRoot
$staging = Join-Path $skillsRoot ('.linkedin-install-' + [guid]::NewGuid().ToString('N'))
$backup = $null
try {
    $null = New-Item -ItemType Directory -Path $staging
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    $baseUrl = 'https://raw.githubusercontent.com/fahim36/linkedin-content-writer/main/skills/linkedin-content-writer'
    foreach ($file in @('SKILL.md', 'agents/openai.yaml', 'references/linkedin-platform.md')) {
        $destination = Join-Path $staging $file
        $null = New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destination)
        Invoke-WebRequest -UseBasicParsing -Uri "$baseUrl/$file" -OutFile $destination
        if ((Get-Item -LiteralPath $destination).Length -eq 0) { throw "Downloaded file is empty: $file" }
    }
    if ((Get-Content -LiteralPath (Join-Path $staging 'SKILL.md') -Raw) -notmatch 'name: linkedin-content-writer') {
        throw 'Downloaded skill has unexpected metadata.'
    }
    if (Test-Path -LiteralPath $target) {
        $backupRoot = Join-Path (Split-Path -Parent $skillsRoot) '.skill-backups'
        $null = New-Item -ItemType Directory -Force -Path $backupRoot
        $backup = Join-Path $backupRoot ($skillName + '-' + [guid]::NewGuid().ToString('N'))
        Move-Item -LiteralPath $target -Destination $backup
    }
    try { Move-Item -LiteralPath $staging -Destination $target }
    catch {
        if ($backup) { Move-Item -LiteralPath $backup -Destination $target }
        throw
    }
    Write-Host "Installed: $target"
    if ($backup) { Write-Host "Previous installation saved: $backup" }
    Write-Host 'Start a new Codex session and use $linkedin-content-writer.'
}
finally {
    # Only remove the uniquely created staging directory inside the chosen root.
    if ((Test-Path -LiteralPath $staging) -and
        ([IO.Path]::GetDirectoryName([IO.Path]::GetFullPath($staging)) -eq $skillsRoot) -and
        ([IO.Path]::GetFileName($staging) -like '.linkedin-install-*')) {
        Remove-Item -LiteralPath $staging -Recurse -Force
    }
}
