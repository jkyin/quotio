# Memory

[← Back to MODULE](MODULE.md) | [← Back to INDEX](../../INDEX.md)

## Summary

| High 🔴 | Medium 🟡 | Low 🟢 |
| 0 | 0 | 9 |

## 🟢 Low Priority

### `NOTE` (Quotio/Services/Proxy/CLIProxyManager.swift:186)

> Bridge mode default is registered in AppDelegate.applicationDidFinishLaunching()

### `NOTE` (Quotio/Services/Proxy/CLIProxyManager.swift:215)

> Changes take effect after proxy restart (CLIProxyAPI does not support live routing API)

### `NOTE` (Quotio/ViewModels/AgentSetupViewModel.swift:351)

> Actual fallback resolution happens at request time in ProxyBridge

### `NOTE` (Quotio/ViewModels/QuotaViewModel.swift:255)

> Cursor and Trae are NOT auto-refreshed - user must use "Scan for IDEs" (issue #29)

### `NOTE` (Quotio/ViewModels/QuotaViewModel.swift:263)

> Cursor and Trae removed from auto-refresh to address privacy concerns (issue #29)

### `NOTE` (Quotio/ViewModels/QuotaViewModel.swift:1017)

> Cursor and Trae removed from auto-refresh (issue #29)

### `NOTE` (Quotio/ViewModels/QuotaViewModel.swift:1037)

> Cursor and Trae require explicit user scan (issue #29)

### `NOTE` (Quotio/ViewModels/QuotaViewModel.swift:1046)

> Cursor and Trae removed - require explicit scan (issue #29)

### `NOTE` (Quotio/ViewModels/QuotaViewModel.swift:1094)

> Don't call detectActiveAccount() here - already set by switch operation

