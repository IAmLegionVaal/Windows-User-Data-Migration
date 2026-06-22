# Windows User Data Migration

> **Testing note:** This was tested by me to be working. User experience may vary.

Included: `Move-WindowsUserData.ps1`

```powershell
.\Move-WindowsUserData.ps1 -Destination 'D:\Migration'
.\Move-WindowsUserData.ps1 -Destination 'D:\Migration' -Copy
.\Move-WindowsUserData.ps1 -Destination 'D:\Migration' -Copy -WhatIf
```

The default mode creates a migration plan. Copy mode transfers selected standard user folders with Robocopy and logs each result. AppData, browser profiles, credentials and encryption keys are intentionally excluded.

Logs: `C:\ProgramData\WindowsUserDataMigration\Logs`

Exit codes: `0` success, `1` fatal error, `2` failed folders.

Verify the destination copy before changing or removing source data. MIT License.
