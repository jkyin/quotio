# Outline

[← Back to MODULE](MODULE.md) | [← Back to INDEX](../../INDEX.md)

Symbol maps for 5 large files in this module.

## Quotio/Views/Screens/DashboardScreen.swift (1006 lines)

| Line | Kind | Name | Visibility |
| ---- | ---- | ---- | ---------- |
| 9 | struct | DashboardScreen | (internal) |
| 564 | fn | handleStepAction | (private) |
| 575 | fn | showProviderPicker | (private) |
| 599 | fn | showAgentPicker | (private) |
| 800 | struct | GettingStartedStep | (internal) |
| 809 | struct | GettingStartedStepRow | (internal) |
| 864 | struct | KPICard | (internal) |
| 892 | struct | ProviderChip | (internal) |
| 916 | struct | FlowLayout | (internal) |
| 930 | fn | layout | (private) |
| 958 | struct | QuotaProviderRow | (internal) |

## Quotio/Views/Screens/FallbackScreen.swift (531 lines)

| Line | Kind | Name | Visibility |
| ---- | ---- | ---- | ---------- |
| 8 | struct | FallbackScreen | (internal) |
| 103 | fn | loadModelsIfNeeded | (private) |
| 317 | struct | VirtualModelsEmptyState | (internal) |
| 359 | struct | VirtualModelRow | (internal) |
| 477 | struct | FallbackEntryRow | (internal) |

## Quotio/Views/Screens/ProvidersScreen.swift (916 lines)

| Line | Kind | Name | Visibility |
| ---- | ---- | ---- | ---------- |
| 16 | struct | ProvidersScreen | (internal) |
| 338 | fn | handleAddProvider | (private) |
| 353 | fn | deleteAccount | (private) |
| 374 | fn | handleEditGlmAccount | (private) |
| 382 | fn | syncCustomProvidersToConfig | (private) |
| 392 | struct | CustomProviderRow | (internal) |
| 493 | struct | MenuBarBadge | (internal) |
| 516 | class | TooltipWindow | (private) |
| 528 | method | init | (private) |
| 558 | fn | show | (internal) |
| 587 | fn | hide | (internal) |
| 593 | class | TooltipTrackingView | (private) |
| 595 | fn | updateTrackingAreas | (internal) |
| 606 | fn | mouseEntered | (internal) |
| 610 | fn | mouseExited | (internal) |
| 614 | fn | hitTest | (internal) |
| 620 | struct | NativeTooltipView | (private) |
| 622 | fn | makeNSView | (internal) |
| 628 | fn | updateNSView | (internal) |
| 634 | mod | extension View | (private) |
| 635 | fn | nativeTooltip | (internal) |
| 642 | struct | MenuBarHintView | (internal) |
| 657 | struct | OAuthSheet | (internal) |
| 783 | struct | OAuthStatusView | (private) |

## Quotio/Views/Screens/QuotaScreen.swift (1246 lines)

| Line | Kind | Name | Visibility |
| ---- | ---- | ---- | ---------- |
| 10 | struct | QuotaScreen | (internal) |
| 38 | fn | accountCount | (private) |
| 57 | fn | lowestQuotaPercent | (private) |
| 179 | struct | ProviderSegmentButton | (private) |
| 240 | struct | QuotaStatusDot | (private) |
| 259 | struct | ProviderQuotaView | (private) |
| 340 | struct | AccountInfo | (private) |
| 352 | struct | AccountQuotaCardV2 | (private) |
| 704 | struct | PlanBadgeV2Compact | (private) |
| 758 | struct | PlanBadgeV2 | (private) |
| 823 | struct | SubscriptionBadgeV2 | (private) |
| 864 | struct | AntigravityDisplayGroup | (private) |
| 874 | struct | AntigravityGroupRow | (private) |
| 971 | struct | AntigravityModelsDetailSheet | (private) |
| 1033 | struct | ModelDetailCard | (private) |
| 1103 | struct | UsageRowV2 | (private) |
| 1212 | struct | QuotaLoadingView | (private) |

## Quotio/Views/Screens/SettingsScreen.swift (2698 lines)

| Line | Kind | Name | Visibility |
| ---- | ---- | ---- | ---------- |
| 10 | struct | SettingsScreen | (internal) |
| 103 | struct | OperatingModeSection | (internal) |
| 168 | fn | handleModeSelection | (private) |
| 187 | fn | switchToMode | (private) |
| 202 | struct | RemoteServerSection | (internal) |
| 323 | fn | saveRemoteConfig | (private) |
| 331 | fn | reconnect | (private) |
| 346 | struct | UnifiedProxySettingsSection | (internal) |
| 557 | fn | loadConfig | (private) |
| 588 | fn | saveProxyURL | (private) |
| 601 | fn | saveRoutingStrategy | (private) |
| 610 | fn | saveSwitchProject | (private) |
| 619 | fn | saveSwitchPreviewModel | (private) |
| 628 | fn | saveRequestRetry | (private) |
| 637 | fn | saveMaxRetryInterval | (private) |
| 646 | fn | saveLoggingToFile | (private) |
| 655 | fn | saveRequestLog | (private) |
| 664 | fn | saveDebugMode | (private) |
| 677 | struct | LocalProxyServerSection | (internal) |
| 733 | struct | LocalPathsSection | (internal) |
| 757 | struct | PathLabel | (internal) |
| 781 | struct | NotificationSettingsSection | (internal) |
| 851 | struct | QuotaDisplaySettingsSection | (internal) |
| 879 | struct | RefreshCadenceSettingsSection | (internal) |
| 918 | struct | UpdateSettingsSection | (internal) |
| 960 | struct | ProxyUpdateSettingsSection | (internal) |
| 1090 | fn | checkForUpdate | (private) |
| 1100 | fn | performUpgrade | (private) |
| 1119 | struct | ProxyVersionManagerSheet | (internal) |
| 1278 | fn | sectionHeader | (private) |
| 1293 | fn | isVersionInstalled | (private) |
| 1297 | fn | refreshInstalledVersions | (private) |
| 1301 | fn | loadReleases | (private) |
| 1315 | fn | installVersion | (private) |
| 1333 | fn | performInstall | (private) |
| 1354 | fn | activateVersion | (private) |
| 1372 | fn | deleteVersion | (private) |
| 1385 | struct | InstalledVersionRow | (private) |
| 1443 | struct | AvailableVersionRow | (private) |
| 1529 | fn | formatDate | (private) |
| 1547 | struct | MenuBarSettingsSection | (internal) |
| 1629 | struct | AppearanceSettingsSection | (internal) |
| 1658 | struct | PrivacySettingsSection | (internal) |
| 1680 | struct | GeneralSettingsTab | (internal) |
| 1731 | struct | AboutTab | (internal) |
| 1758 | struct | AboutScreen | (internal) |
| 1973 | struct | AboutUpdateSection | (internal) |
| 2029 | struct | AboutProxyUpdateSection | (internal) |
| 2165 | fn | checkForUpdate | (private) |
| 2175 | fn | performUpgrade | (private) |
| 2194 | struct | VersionBadge | (internal) |
| 2246 | struct | AboutUpdateCard | (internal) |
| 2337 | struct | AboutProxyUpdateCard | (internal) |
| 2494 | fn | checkForUpdate | (private) |
| 2504 | fn | performUpgrade | (private) |
| 2523 | struct | LinkCard | (internal) |
| 2610 | struct | ManagementKeyRow | (internal) |

