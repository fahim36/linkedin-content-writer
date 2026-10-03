# Standalone Claude Code entry point; uses the shared backup-preserving installer.
param([string]$SkillsDirectory)
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
$installer = Invoke-RestMethod 'https://raw.githubusercontent.com/fahim36/linkedin-content-writer/main/install-online.ps1'
& ([scriptblock]::Create($installer)) -Agent ClaudeCode -SkillsDirectory $SkillsDirectory
