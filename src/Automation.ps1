# Automation.ps1 — 自动化调度
# 镜头 023-024：关机钩子 · 开机对话框 · 一键安装/卸载
# 使用 schtasks.exe 兼容 PowerShell 5.1

. "$PSScriptRoot\Snapshot.ps1"
. "$PSScriptRoot\DeepSeek.ps1"
. "$PSScriptRoot\AnaBridge.ps1"

function Register-ATAStartupTask {
    $taskName = "ATA-StartupDialog"
    $ps1 = "$PSScriptRoot\Show-StartupDialog.ps1"
    try {
        schtasks /Create /TN $taskName /SC ONLOGON /TR "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File \`"$ps1\`"" /F /RL LIMITED 2>&1 | Out-Null
        Write-Host "  Startup dialog: on" -ForegroundColor Green
    } catch {
        Write-Host "  Startup dialog: needs Admin (run PowerShell as Administrator)" -ForegroundColor Yellow
    }
}

function Register-ATAShutdownHook {
    $taskName = "ATA-AutoSave"
    $snapScript = "$PSScriptRoot\Snapshot.ps1"
    try {
        schtasks /Create /TN $taskName /SC MINUTE /MO 30 /TR "powershell.exe -ExecutionPolicy Bypass -Command \`". '$snapScript'; Save-ATA -Type auto\`"" /F /RL LIMITED 2>&1 | Out-Null
        Write-Host "  Auto-save: every 30 min" -ForegroundColor Green
    } catch {
        Write-Host "  Auto-save: needs Admin" -ForegroundColor Yellow
    }
}

function Show-StartupDialog {
    $snapshots = @(Get-ATASnapshots -Last 5)
    if ($snapshots.Count -eq 0) { return }
    Write-Host "`n============================================" -ForegroundColor Magenta
    Write-Host "  ATA - Restore Your Workspace?" -ForegroundColor White
    Write-Host "============================================" -ForegroundColor Magenta
    $idx = 1
    foreach ($s in $snapshots) {
        try {
            $d = Get-Content $s.FullName -Raw | ConvertFrom-Json
            Write-Host "  [$idx] $($d.snapshot.created) | $($d.snapshot.windows.Count) apps" -ForegroundColor Gray
        } catch { Write-Host "  [$idx] $($s.Name)" -ForegroundColor Gray }
        $idx++
    }
    Write-Host "  [0] Skip" -ForegroundColor Gray
    Write-Host ""
    $choice = Read-Host "Choice [default=1]"
    if (-not $choice) { $choice = 1 }
    if ($choice -eq 0) { Write-Host "Skipped." -ForegroundColor Gray; return }
    if ($choice -lt 1 -or $choice -gt $snapshots.Count) { $choice = 1 }
    $selected = $snapshots[$choice - 1]
    Write-Host "Restoring: $($selected.Name)..." -ForegroundColor Cyan
    . "$PSScriptRoot\Restore.ps1"
    Restore-ATA -SnapshotPath $selected.FullName -Yes -SkipMissing
}

function Install-ATA {
    Write-Host "`nATA Install" -ForegroundColor Cyan
    Write-Host "--------------"
    $dirs = @("$env:APPDATA\ATA\snapshots", "$env:APPDATA\ATA\logs")
    foreach ($d in $dirs) {
        if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
    }
    Register-ATAStartupTask
    Register-ATAShutdownHook
    $desktop = [Environment]::GetFolderPath('Desktop')
    Copy-Item "$PSScriptRoot\..\ATA.bat" "$desktop\ATA.bat" -Force
    Write-Host "  Desktop shortcut: updated" -ForegroundColor Gray
    Write-Host "`nDone. Double-click ATA icon on desktop to save/restore." -ForegroundColor Green
    Write-Host "Startup dialog + auto-save registered." -ForegroundColor Gray
}

function Uninstall-ATA {
    Write-Host "`nATA Uninstall" -ForegroundColor Cyan
    $tasks = @("ATA-StartupDialog", "ATA-ShutdownSave", "ATA-AutoSave")
    foreach ($t in $tasks) {
        schtasks /Delete /TN $t /F 2>&1 | Out-Null
        Write-Host "  Removed: $t" -ForegroundColor Gray
    }
    Write-Host "Snapshots kept at: $env:APPDATA\ATA\" -ForegroundColor Green
}
