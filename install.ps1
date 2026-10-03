# Forward all arguments to the cross-platform installer.
$ErrorActionPreference = 'Stop'
$installer = Join-Path $PSScriptRoot 'install.py'
if (Get-Command python -ErrorAction SilentlyContinue) {
    & python $installer @args
} elseif (Get-Command py -ErrorAction SilentlyContinue) {
    & py -3 $installer @args
} else {
    throw 'Python 3.9 or newer is required. Install Python, then run this script again.'
}
exit $LASTEXITCODE
