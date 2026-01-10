# Quotio/Views/Screens/SettingsScreen.swift

[← Back to Module](../modules/Quotio-Views-Screens/MODULE.md) | [← Back to INDEX](../INDEX.md)

## Overview

- **Lines:** 2698
- **Language:** Swift
- **Symbols:** 57
- **Public symbols:** 0

## Symbol Table

| Line | Kind | Name | Visibility | Signature |
| ---- | ---- | ---- | ---------- | --------- |
| 10 | struct | SettingsScreen | (internal) | `struct SettingsScreen` |
| 103 | struct | OperatingModeSection | (internal) | `struct OperatingModeSection` |
| 168 | fn | handleModeSelection | (private) | `private func handleModeSelection(_ mode: Operat...` |
| 187 | fn | switchToMode | (private) | `private func switchToMode(_ mode: OperatingMode)` |
| 202 | struct | RemoteServerSection | (internal) | `struct RemoteServerSection` |
| 323 | fn | saveRemoteConfig | (private) | `private func saveRemoteConfig(_ config: RemoteC...` |
| 331 | fn | reconnect | (private) | `private func reconnect()` |
| 346 | struct | UnifiedProxySettingsSection | (internal) | `struct UnifiedProxySettingsSection` |
| 557 | fn | loadConfig | (private) | `private func loadConfig() async` |
| 588 | fn | saveProxyURL | (private) | `private func saveProxyURL() async` |
| 601 | fn | saveRoutingStrategy | (private) | `private func saveRoutingStrategy(_ strategy: St...` |
| 610 | fn | saveSwitchProject | (private) | `private func saveSwitchProject(_ enabled: Bool)...` |
| 619 | fn | saveSwitchPreviewModel | (private) | `private func saveSwitchPreviewModel(_ enabled: ...` |
| 628 | fn | saveRequestRetry | (private) | `private func saveRequestRetry(_ count: Int) async` |
| 637 | fn | saveMaxRetryInterval | (private) | `private func saveMaxRetryInterval(_ seconds: In...` |
| 646 | fn | saveLoggingToFile | (private) | `private func saveLoggingToFile(_ enabled: Bool)...` |
| 655 | fn | saveRequestLog | (private) | `private func saveRequestLog(_ enabled: Bool) async` |
| 664 | fn | saveDebugMode | (private) | `private func saveDebugMode(_ enabled: Bool) async` |
| 677 | struct | LocalProxyServerSection | (internal) | `struct LocalProxyServerSection` |
| 733 | struct | LocalPathsSection | (internal) | `struct LocalPathsSection` |
| 757 | struct | PathLabel | (internal) | `struct PathLabel` |
| 781 | struct | NotificationSettingsSection | (internal) | `struct NotificationSettingsSection` |
| 851 | struct | QuotaDisplaySettingsSection | (internal) | `struct QuotaDisplaySettingsSection` |
| 879 | struct | RefreshCadenceSettingsSection | (internal) | `struct RefreshCadenceSettingsSection` |
| 918 | struct | UpdateSettingsSection | (internal) | `struct UpdateSettingsSection` |
| 960 | struct | ProxyUpdateSettingsSection | (internal) | `struct ProxyUpdateSettingsSection` |
| 1090 | fn | checkForUpdate | (private) | `private func checkForUpdate()` |
| 1100 | fn | performUpgrade | (private) | `private func performUpgrade(to version: ProxyVe...` |
| 1119 | struct | ProxyVersionManagerSheet | (internal) | `struct ProxyVersionManagerSheet` |
| 1278 | fn | sectionHeader | (private) | `@ViewBuilder   private func sectionHeader(_ tit...` |
| 1293 | fn | isVersionInstalled | (private) | `private func isVersionInstalled(_ version: Stri...` |
| 1297 | fn | refreshInstalledVersions | (private) | `private func refreshInstalledVersions()` |
| 1301 | fn | loadReleases | (private) | `private func loadReleases() async` |
| 1315 | fn | installVersion | (private) | `private func installVersion(_ release: GitHubRe...` |
| 1333 | fn | performInstall | (private) | `private func performInstall(_ release: GitHubRe...` |
| 1354 | fn | activateVersion | (private) | `private func activateVersion(_ version: String)` |
| 1372 | fn | deleteVersion | (private) | `private func deleteVersion(_ version: String)` |
| 1385 | struct | InstalledVersionRow | (private) | `struct InstalledVersionRow` |
| 1443 | struct | AvailableVersionRow | (private) | `struct AvailableVersionRow` |
| 1529 | fn | formatDate | (private) | `private func formatDate(_ isoString: String) ->...` |
| 1547 | struct | MenuBarSettingsSection | (internal) | `struct MenuBarSettingsSection` |
| 1629 | struct | AppearanceSettingsSection | (internal) | `struct AppearanceSettingsSection` |
| 1658 | struct | PrivacySettingsSection | (internal) | `struct PrivacySettingsSection` |
| 1680 | struct | GeneralSettingsTab | (internal) | `struct GeneralSettingsTab` |
| 1731 | struct | AboutTab | (internal) | `struct AboutTab` |
| 1758 | struct | AboutScreen | (internal) | `struct AboutScreen` |
| 1973 | struct | AboutUpdateSection | (internal) | `struct AboutUpdateSection` |
| 2029 | struct | AboutProxyUpdateSection | (internal) | `struct AboutProxyUpdateSection` |
| 2165 | fn | checkForUpdate | (private) | `private func checkForUpdate()` |
| 2175 | fn | performUpgrade | (private) | `private func performUpgrade(to version: ProxyVe...` |
| 2194 | struct | VersionBadge | (internal) | `struct VersionBadge` |
| 2246 | struct | AboutUpdateCard | (internal) | `struct AboutUpdateCard` |
| 2337 | struct | AboutProxyUpdateCard | (internal) | `struct AboutProxyUpdateCard` |
| 2494 | fn | checkForUpdate | (private) | `private func checkForUpdate()` |
| 2504 | fn | performUpgrade | (private) | `private func performUpgrade(to version: ProxyVe...` |
| 2523 | struct | LinkCard | (internal) | `struct LinkCard` |
| 2610 | struct | ManagementKeyRow | (internal) | `struct ManagementKeyRow` |

