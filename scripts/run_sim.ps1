param(
    [string]$VivadoBin = '',
    [ValidateSet('all','tb_game_core','tb_display','tb_control','tb_top')]
    [string]$Test = 'all'
)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
if (!$VivadoBin) {
    if ($env:XILINX_VIVADO) { $VivadoBin = Join-Path $env:XILINX_VIVADO 'bin' }
    else {
        $found = Get-Command xvlog.bat -ErrorAction SilentlyContinue
        if ($found) { $VivadoBin = Split-Path -Parent $found.Source }
        else { throw 'Pass -VivadoBin with the Vivado bin folder, or use a Vivado shell.' }
    }
}
foreach ($tool in @('xvlog','xelab','xsim')) {
    if (!(Test-Path -LiteralPath (Join-Path $VivadoBin "$tool.bat"))) {
        throw "Missing Vivado tool: $tool"
    }
}
$runDir = Join-Path $repoRoot 'build/sim'
New-Item -ItemType Directory -Force -Path $runDir | Out-Null
$rtl = @(Get-ChildItem -LiteralPath (Join-Path $repoRoot 'rtl') -Filter '*.v' -Recurse | Sort-Object FullName | ForEach-Object { $_.FullName })
$benches = @(Get-ChildItem -LiteralPath (Join-Path $repoRoot 'sim') -Filter 'tb_*.sv' | Sort-Object FullName | ForEach-Object { $_.FullName })
$tests = if ($Test -eq 'all') { @('tb_game_core','tb_display','tb_control','tb_top') } else { @($Test) }
Push-Location $runDir
try {
    & (Join-Path $VivadoBin 'xvlog.bat') -i (Join-Path $repoRoot 'rtl/include') @rtl
    if ($LASTEXITCODE -ne 0) { throw 'RTL Verilog compilation failed.' }
    & (Join-Path $VivadoBin 'xvlog.bat') --sv -i (Join-Path $repoRoot 'rtl/include') @benches
    if ($LASTEXITCODE -ne 0) { throw 'Test bench compilation failed.' }
    foreach ($name in $tests) {
        & (Join-Path $VivadoBin 'xelab.bat') $name -s "${name}_snapshot" --debug typical
        if ($LASTEXITCODE -ne 0) { throw "Elaboration failed: $name" }
        & (Join-Path $VivadoBin 'xsim.bat') "${name}_snapshot" -runall -log "$name.log"
        if ($LASTEXITCODE -ne 0) { throw "Simulation failed: $name" }
        $result = Get-Content -LiteralPath "$name.log" -Raw
        if ($result -match '(?im)^\s*(Fatal|Error|FAIL)\b' -or $result -notmatch "PASS: $name") {
            throw "Missing PASS or failure in $name.log"
        }
    }
    Write-Host 'Framework smoke checks passed. Functional acceptance is still pending.'
} finally { Pop-Location }
