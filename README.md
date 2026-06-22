# Windows User Data Migration

> **Testing note:** This was tested by me to be working. User experience may vary.

## One-click use

1. Download and extract the repository.
2. Double-click `Run-OneClick.bat` while signed in as the intended Windows user.
3. Enter the destination folder when prompted, such as `D:\Migration`.
4. Review the displayed exit code, destination files and generated logs.

The launcher runs the supported copy workflow directly. There is no menu.

Included: `Move-WindowsUserData.ps1`

## PowerShell usage

```powershell
.\Move-WindowsUserData.ps1 -Destination 'D:\Migration'
.\Move-WindowsUserData.ps1 -Destination 'D:\Migration' -Copy
.\Move-WindowsUserData.ps1 -Destination 'D:\Migration' -Copy -WhatIf
```

The default PowerShell mode creates a migration plan. Copy mode transfers selected standard user folders with Robocopy and records each result. AppData, browser profiles, credential stores and encryption keys are intentionally outside the supported scope.

Logs: `C:\ProgramData\WindowsUserDataMigration\Logs`

Exit codes: `0` success, `1` fatal error, `2` failed folders.

Check the destination results before relying on the copy. MIT License.
