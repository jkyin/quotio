//
//  MenuBarView.swift
//  Quotio
//

import SwiftUI

struct MenuBarView: View {
    @Environment(QuotaViewModel.self) private var viewModel
    @Environment(\.openWindow) private var openWindow
    
    private var allQuotas: [(provider: AIProvider, email: String, data: ProviderQuotaData)] {
        var result: [(provider: AIProvider, email: String, data: ProviderQuotaData)] = []
        
        for (provider, quotas) in viewModel.providerQuotas {
            for (email, data) in quotas where !data.models.isEmpty {
                result.append((provider: provider, email: email, data: data))
            }
        }
        
        return result.sorted { $0.provider.displayName < $1.provider.displayName }
    }
    
    private var hasQuotaData: Bool {
        !allQuotas.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            
            Divider()
                .padding(.vertical, 8)
            
            if viewModel.proxyManager.proxyStatus.running {
                statsSection
                
                Divider()
                    .padding(.vertical, 8)
                
                if hasQuotaData {
                    quotaSection
                    
                    Divider()
                        .padding(.vertical, 8)
                }
                
                providersSection
                
                Divider()
                    .padding(.vertical, 8)
            }
            
            actionsSection
        }
        .padding(12)
        .frame(width: 320)
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        HStack(spacing: 12) {
            // Status indicator
            ZStack {
                Circle()
                    .fill(viewModel.proxyManager.proxyStatus.running ? Color.green : Color.gray)
                    .frame(width: 12, height: 12)
                
                if viewModel.proxyManager.proxyStatus.running {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 12, height: 12)
                        .opacity(0.5)
                        .scaleEffect(1.5)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: viewModel.proxyManager.proxyStatus.running)
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Quotio")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(viewModel.proxyManager.proxyStatus.running 
                     ? "menubar.running".localized() 
                     : "menubar.stopped".localized())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Toggle button
            Button {
                Task { await viewModel.toggleProxy() }
            } label: {
                Image(systemName: viewModel.proxyManager.proxyStatus.running ? "stop.fill" : "play.fill")
                    .font(.title3)
                    .foregroundStyle(viewModel.proxyManager.proxyStatus.running ? .red : .green)
            }
            .buttonStyle(.plain)
            .help(viewModel.proxyManager.proxyStatus.running 
                  ? "action.stopProxy".localized() 
                  : "action.startProxy".localized())
        }
    }
    
    // MARK: - Stats Section
    
    private var statsSection: some View {
        VStack(spacing: 8) {
            // Endpoint
            HStack {
                Image(systemName: "link")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(viewModel.proxyManager.proxyStatus.endpoint)
                    .font(.system(.caption, design: .monospaced))
                    .lineLimit(1)
                
                Spacer()
                
                Button {
                    viewModel.proxyManager.copyEndpointToClipboard()
                } label: {
                    Image(systemName: "doc.on.doc")
                        .font(.caption)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
            }
            
            // Quick stats row
            HStack(spacing: 16) {
                StatItem(
                    icon: "person.2.fill",
                    value: "\(viewModel.readyAccounts)/\(viewModel.totalAccounts)",
                    label: "menubar.accounts".localized(),
                    color: .blue
                )
                
                StatItem(
                    icon: "arrow.up.arrow.down",
                    value: "\(viewModel.usageStats?.usage?.totalRequests ?? 0)",
                    label: "menubar.requests".localized(),
                    color: .green
                )
                
                StatItem(
                    icon: "checkmark.circle",
                    value: String(format: "%.0f%%", viewModel.usageStats?.usage?.successRate ?? 0.0),
                    label: "menubar.success".localized(),
                    color: .orange
                )
            }
        }
    }
    
    // MARK: - Quota Section
    
    private var quotaSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("menubar.quota".localized())
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                if viewModel.isLoadingQuotas {
                    ProgressView()
                        .controlSize(.mini)
                }
            }
            
            ForEach(allQuotas.prefix(4), id: \.email) { item in
                QuotaAccountRow(provider: item.provider, email: item.email, data: item.data)
            }
            
            if allQuotas.count > 4 {
                Text("menubar.andMore".localized()
                    .replacingOccurrences(of: "{count}", with: "\(allQuotas.count - 4)"))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
    }
    
    // MARK: - Providers Section
    
    private var providersSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("menubar.providers".localized())
                .font(.caption)
                .foregroundStyle(.secondary)
            
            if viewModel.connectedProviders.isEmpty {
                Text("menubar.noProviders".localized())
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.vertical, 4)
            } else {
                ForEach(viewModel.connectedProviders.prefix(4)) { provider in
                    ProviderRow(
                        provider: provider,
                        accounts: viewModel.authFilesByProvider[provider] ?? []
                    )
                }
                
                if viewModel.connectedProviders.count > 4 {
                    Text("menubar.andMore".localized()
                        .replacingOccurrences(of: "{count}", with: "\(viewModel.connectedProviders.count - 4)"))
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
        }
    }
    
    // MARK: - Actions Section
    
    private var actionsSection: some View {
        VStack(spacing: 4) {
            // Open main window
            Button {
                openMainWindow()
            } label: {
                HStack {
                    Image(systemName: "macwindow")
                    Text("menubar.openApp".localized())
                    Spacer()
                    Text("⌘O")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .buttonStyle(.plain)
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .background(.quaternary.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 6))
            
            // Refresh
            Button {
                Task { await viewModel.refreshData() }
            } label: {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("action.refresh".localized())
                    Spacer()
                    Text("⌘R")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .buttonStyle(.plain)
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .disabled(!viewModel.proxyManager.proxyStatus.running)
            
            Divider()
                .padding(.vertical, 4)
            
            // Quit
            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                HStack {
                    Image(systemName: "power")
                    Text("menubar.quit".localized())
                    Spacer()
                    Text("⌘Q")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .buttonStyle(.plain)
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
        }
    }
    
    private func openMainWindow() {
        NSApplication.shared.activate(ignoringOtherApps: true)
        
        if let window = NSApplication.shared.windows.first(where: { 
            $0.title == "Quotio" && $0.isVisible == false 
        }) {
            window.makeKeyAndOrderFront(nil)
        } else if let window = NSApplication.shared.windows.first(where: { 
            $0.title == "Quotio" 
        }) {
            window.makeKeyAndOrderFront(nil)
        } else {
            openWindow(id: "main")
        }
    }
}

// MARK: - Supporting Views

private struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundStyle(color)
                
                Text(value)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct ProviderRow: View {
    let provider: AIProvider
    let accounts: [AuthFile]
    
    private var readyCount: Int {
        accounts.filter { $0.isReady }.count
    }
    
    private var statusColor: Color {
        if readyCount == accounts.count { return .green }
        if readyCount > 0 { return .orange }
        return .red
    }
    
    var body: some View {
        HStack(spacing: 8) {
            ProviderIcon(provider: provider, size: 16)
            
            Text(provider.displayName)
                .font(.caption)
                .lineLimit(1)
            
            Spacer()
            
            HStack(spacing: 4) {
                Circle()
                    .fill(statusColor)
                    .frame(width: 6, height: 6)
                
                Text("\(readyCount)/\(accounts.count)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

private struct QuotaAccountRow: View {
    let provider: AIProvider
    let email: String
    let data: ProviderQuotaData
    
    private var lowestQuotaModel: ModelQuota? {
        data.models.min { $0.percentage < $1.percentage }
    }
    
    private var overallColor: Color {
        guard let lowest = lowestQuotaModel else { return .gray }
        let remaining = lowest.percentage
        if remaining > 50 { return .green }
        if remaining > 20 { return .orange }
        return .red
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                ProviderIcon(provider: provider, size: 14)
                
                Text(email)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Spacer()
                
                if data.isForbidden {
                    Text("Limit")
                        .font(.caption2)
                        .foregroundStyle(.red)
                }
            }
            
            if !data.models.isEmpty {
                HStack(spacing: 8) {
                    ForEach(data.models.sorted { $0.name < $1.name }.prefix(3)) { model in
                        QuotaModelBadge(model: model)
                    }
                }
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(.quaternary.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

private struct QuotaModelBadge: View {
    let model: ModelQuota
    
    private var remainingPercent: Double {
        model.percentage
    }
    
    private var tintColor: Color {
        if remainingPercent > 50 { return .green }
        if remainingPercent > 20 { return .orange }
        return .red
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(model.displayName)
                .font(.system(size: 9))
                .foregroundStyle(.secondary)
                .lineLimit(1)
            
            HStack(spacing: 4) {
                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.quaternary)
                        Capsule()
                            .fill(tintColor.gradient)
                            .frame(width: proxy.size.width * min(1, remainingPercent / 100))
                    }
                }
                .frame(height: 4)
                
                Text(model.formattedPercentage)
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundStyle(tintColor)
                    .frame(width: 36, alignment: .trailing)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Menu Bar Icon

struct MenuBarIcon: View {
    let isRunning: Bool
    let readyAccounts: Int
    let totalAccounts: Int
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "gauge.with.dots.needle.67percent")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(isRunning ? .green : .secondary)
            
            if isRunning && totalAccounts > 0 {
                Text("\(readyAccounts)/\(totalAccounts)")
                    .font(.caption2)
                    .fontWeight(.medium)
            }
        }
    }
}
