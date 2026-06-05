# ATA Roadmap

> Atlas Time Archive — Desktop Session Time Capsule
> Last updated: 2026-06-05

---

## Phase 1 · Foundation — "Take the Photo"

**Status: ✅ Complete**

Core snapshot engine. Enumerate every visible window, capture position/size/state/title, record monitor layout, export to JSON.

| Deliverable | Description |
|---|---|
| `Window.ps1` | Win32 API wrapper — `GetWindowRect`, `GetWindowState`, `GetWindowTitle`, `GetWindowClass`, `Test-IsValidAppWindow` (9 functions) |
| `Monitor.ps1` | Display detection — WMI + .NET Screen API, `Get-MonitorInfo`, `Get-MonitorSummary` |
| `Snapshot.ps1` | Snapshot engine — `Get-ATAWindows`, `Resolve-WindowMonitors`, `Mark-FocusedWindow`, `Save-ATA`, `Test-ATASnapshot` (6 functions) |
| `snapshot-v1.0.json` | JSON Schema — reserved fields for `appState`, `adapter`, `event`, `ecosystem`, `deepseek` |
| `config.json` | Runtime config — `%APPDATA%\ATA\config.json` with 6 sections |

**Self-check**: `.\ata.ps1 save` produces a valid JSON snapshot with all open windows.

---

## Phase 2 · Resurrection — "Develop the Photo"

**Status: ✅ Complete**

One-click restore engine. Read JSON snapshot, detect current monitor config, launch applications in dependency order, position windows to saved coordinates.

| Deliverable | Description |
|---|---|
| `Restore.ps1` | Restore engine — `Start-ATAApp`, `Set-WindowPosition`, `Get-CoordinateMapping`, `Restore-ATA`, `ata log`, `ata clean` (8 functions) |
| `Explorer.ps1` | File Explorer adapter — COM `Shell.Application` enumeration, folder path capture/restore |
| Priority launch | Infrastructure apps (Clash Verge, VPN) launch first with 3s extra delay |
| Rollback | `ata restore 20260605` — restore any historical snapshot by date |
| Dry-run | `ata restore --dry-run` — preview without executing |

**Self-check**: `.\ata.ps1 restore` brings back 70%+ of windows to correct positions.

---

## Phase 3 · Awakening — "AI Understands Your Work"

**Status: 🟡 In Progress (70%)**

AI insight engine, startup/shutdown automation, Obsidian bridge.

| Deliverable | Status |
|---|---|
| `DeepSeek.ps1` — dual-provider AI (DeepSeek/OpenAI, config-switchable) | ✅ Code complete |
| Instant insight — 1-2 line summary on each save | ✅ Code complete |
| Daily insight — 3-5 line brief, today vs yesterday diff | ✅ Code complete |
| Weekly insight — work-pattern report with optimization tips | ✅ Code complete |
| `Automation.ps1` — `Install-ATA` registers startup dialog + 30min auto-save via `schtasks.exe` | ✅ Working |
| Desktop shortcut — `ATA.bat` with logo icon, one-click save | ✅ Working |
| `AnaBridge.ps1` — save writes Obsidian daily note, restore opens it | ⬜ Code ready, needs config |
| AI credit application | ⬜ Pending OpenAI approval |

**Self-check**: `.\ata.ps1 insight` returns AI-generated work summary (requires API key).

---

## Phase 4 · Network — "Five Projects Breathe Together"

**Status: ⬜ Planned (1-2 weeks)**

Unified event bus connecting all 5 projects. Cross-project awareness.

| Deliverable | Description |
|---|---|
| Event bus JSONL | `%APPDATA%\Ecosystem\events\YYYY-MM-DD.jsonl` — append-only, one JSON line per event |
| Cross-project config | One `DEEPSEEK_API_KEY`, all 5 projects read from shared config |
| Snapshot → Obsidian diary | Shutdown snapshot auto-writes daily note with workspace summary |
| Restore → Obsidian diary | Restore auto-opens the corresponding day's ANA note |
| Adapter marketplace scaffold | `adapters/` directory with template, README, contribution guide |
| Save-ATA-Full | Integrated save: snapshot + AI insight + Obsidian diary + event emission |

**Self-check**: After shutdown and restore, Obsidian shows today's workspace diary entry with AI insight.

---

## Phase 5 · Evolution — "Native Windows Application"

**Status: ⬜ Planned (1-3 months)**

Rewrite from PowerShell scripts to C# / .NET native application.

| Deliverable | Description |
|---|---|
| C# rewrite | Same JSON schema, native performance, proper multi-threading |
| System tray icon | Right-click → Save / Restore / Insights / Settings |
| WPF restore dialog | Logo + snapshot selector + "Restore" / "Skip" buttons |
| SQLite snapshot DB | Fast query, tags, search — "What was I working on last Wednesday?" |
| MSI installer + winget | `winget install ata` — zero-terminal setup for non-programmers |
| Auto-update | Background update check via GitHub Releases |
| Adapter marketplace | Community-submitted adapters with versioning and compatibility tags |
| Restore success rate ≥ 90% | Cover Explorer, Chrome tabs, VS Code workspace, Terminal CWD |

**Self-check**: Non-technical user installs via `winget`, clicks tray icon, restores workspace in one click.

---

## Phase 6 · Boundary Break — "Cross-Platform Workspace Infrastructure"

**Status: ⬜ Vision (6-12 months)**

Same JSON schema, different OS backends. Workspace portability.

| Deliverable | Description |
|---|---|
| macOS backend | Accessibility API + AppleScript for window enumeration and positioning |
| Linux backend | X11/Wayland compositor integration per desktop environment |
| Cloud sync (optional, encrypted) | Save on office PC → restore on home PC via end-to-end encrypted sync |
| Team shared workspaces | "New hire onboarding: one-click restore team's standard dev environment" |
| Obsidian plugin | Manage snapshots, view work journals, trigger restore — all from within Obsidian |
| REST API | `POST /snapshots` / `GET /snapshots/latest` — integrate with any tool |

**Self-check**: Snap a workspace on Windows, restore it on macOS, with monitor layout adaptation.

---

## Visual Timeline

```
Phase 1 ──── Phase 2 ──── Phase 3 ──── Phase 4 ──── Phase 5 ──── Phase 6
  ✅           ✅           🟡            ⬜            ⬜            ⬜
 Save        Restore    AI+Auto        Event       Native      Cross-Plat
 Engine      Engine     Insight         Bus         App        form

Day 1        Day 1      Day 1-3       Week 2-3    Month 1-3   Month 6-12
(Complete)  (Complete)  (In Progress)  (Planned)   (Planned)   (Vision)
```

---

## Key Metrics

| Metric | Current | Target (Phase 5) |
|---|---|---|
| Restore success rate | ~50-60% | ≥ 90% |
| Apps with adapters | 1 (Explorer) | 10+ (Chrome, VS Code, Terminal, Figma, Obsidian, Slack...) |
| Lines of code | ~1,200 | ~5,000 (C# rewrite) |
| GitHub stars | — | 200+ |
| External contributors | 0 | 5+ |

---

*ATA = Atlas Time Archive. Carry your digital world across reboots.*
