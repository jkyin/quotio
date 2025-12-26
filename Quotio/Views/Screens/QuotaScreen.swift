//
//  QuotaScreen.swift
//  Quotio
//

import SwiftUI

struct QuotaScreen: View {
    @Environment(QuotaViewModel.self) private var viewModel
    
    private var providerGroups: [(AIProvider, [AuthFile])] {
        let grouped = Dictionary(grouping: viewModel.authFiles) { $0.providerType }
        return AIProvider.allCases.compactMap { provider in
            guard let files = grouped[provider], !files.isEmpty else { return nil }
            return (provider, files)
        }
    }
    
    private var totalReady: Int {
        viewModel.authFiles.filter { $0.isReady }.count
    }
    
    private var totalAccounts: Int {
        viewModel.authFiles.count
    }
    
    private var providerCount: Int {
        providerGroups.count
    }
    
    var body: some View {
        Group {
            if !viewModel.proxyManager.proxyStatus.running {
                ContentUnavailableView(
                    "empty.proxyNotRunning".localized(),
                    systemImage: "bolt.slash",
                    description: Text("empty.startProxyToView".localized())
                )
            } else if viewModel.authFiles.isEmpty {
                ContentUnavailableView(
                    "empty.noAccounts".localized(),
                    systemImage: "person.crop.circle.badge.questionmark",
                    description: Text("empty.addProviderAccounts".localized())
                )
            } else {
                ScrollView {
                    VStack(spacing: 24) {
                        SummaryCard(
                            totalReady: totalReady,
                            totalAccounts: totalAccounts,
                            providerCount: providerCount
                        )
                        
                        LazyVStack(spacing: 20) {
                            ForEach(providerGroups, id: \.0) { provider, accounts in
                                ProviderQuotaSection(
                                    provider: provider,
                                    accounts: accounts,
                                    quotaData: viewModel.providerQuotas[provider],
                                    isLoading: viewModel.isLoadingQuotas
                                )
                            }
                        }
                    }
                    .padding(20)
                }
            }
        }
        .navigationTitle("nav.quota".localized())
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    Task { await viewModel.refreshAllQuotas() }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(!viewModel.proxyManager.proxyStatus.running || viewModel.isLoadingQuotas)
            }
        }
    }
}

private struct ProviderQuotaSection: View {
    let provider: AIProvider
    let accounts: [AuthFile]
    let quotaData: [String: ProviderQuotaData]?
    let isLoading: Bool
    
    var body: some View {
        Section {
            ForEach(accounts) { account in
                AccountQuotaCard(
                    provider: provider,
                    account: account,
                    quotaData: quotaData?[account.quotaLookupKey],
                    isLoading: isLoading && quotaData?[account.quotaLookupKey] == nil
                )
            }
        } header: {
            HStack {
                ProviderIcon(provider: provider, size: 24)
                Text(provider.displayName)
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(accounts.count) " + "quota.accounts".localized())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 4)
        }
    }
}

struct AccountQuotaCard: View {
    @Environment(QuotaViewModel.self) private var viewModel
    let provider: AIProvider
    let account: AuthFile
    let quotaData: ProviderQuotaData?
    var isLoading: Bool = false
    
    @State private var isRefreshing = false
    
    private var hasQuotaData: Bool {
        guard let data = quotaData else { return false }
        return !data.models.isEmpty
    }
    
    private var subscriptionInfo: SubscriptionInfo? {
        return viewModel.subscriptionInfos[account.quotaLookupKey]
    }
    
    private var isLoadingSubscription: Bool {
        return viewModel.isLoadingQuotas && viewModel.subscriptionInfos[account.quotaLookupKey] == nil
    }
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    Circle()
                        .fill(account.statusColor)
                        .frame(width: 12, height: 12)
                    
                    Text(account.email ?? account.name)
                        .font(.body)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button {
                        Task {
                            isRefreshing = true
                            await viewModel.refreshQuotaForProvider(provider)
                            isRefreshing = false
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.subheadline)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .disabled(isRefreshing || isLoading)
                    .opacity(isRefreshing ? 0.5 : 1)
                    
                    if let data = quotaData, data.isForbidden {
                        Label("status.forbidden".localized(), systemImage: "exclamationmark.triangle.fill")
                            .font(.subheadline)
                            .foregroundStyle(.red)
                    } else {
                        StatusBadge(status: account.status, color: account.statusColor)
                    }
                }
                
                if isLoadingSubscription {
                    SubscriptionSkeletonView()
                } else if let info = subscriptionInfo {
                    SubscriptionBadge(info: info)
                } else if let planName = quotaData?.planDisplayName {
                    PlanBadge(planName: planName)
                }
                
                if isLoading {
                    QuotaSkeletonView()
                } else if hasQuotaData, let data = quotaData {
                    Divider()
                        .padding(.vertical, 4)
                    
                    VStack(spacing: 16) {
                        ForEach(data.models.sorted { $0.name < $1.name }) { model in
                            ModelQuotaRow(model: model)
                        }
                    }
                } else if let message = account.statusMessage, !message.isEmpty {
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }
            }
            .padding(12)
        }
    }
}

private struct StatusBadge: View {
    let status: String
    let color: Color
    
    var body: some View {
        Text(status.capitalized)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}

private struct PlanBadge: View {
    let planName: String
    
    private var planColor: Color {
        switch planName.lowercased() {
        case "pro": return .purple
        case "plus": return .blue
        case "team": return .orange
        case "enterprise": return .red
        default: return .gray
        }
    }
    
    private var planIcon: String {
        switch planName.lowercased() {
        case "pro": return "crown.fill"
        case "plus": return "plus.circle.fill"
        case "team": return "person.3.fill"
        case "enterprise": return "building.2.fill"
        default: return "person.fill"
        }
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: planIcon)
                .font(.subheadline)
            Text(planName)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(planColor.opacity(0.15))
        .foregroundStyle(planColor)
        .clipShape(Capsule())
    }
}

private struct SubscriptionBadge: View {
    let info: SubscriptionInfo
    
    private var tierColor: Color {
        switch info.tierId {
        case "g1-pro-tier": return .purple
        case "standard-tier": return .blue
        default: return .gray
        }
    }
    
    private var tierIcon: String {
        switch info.tierId {
        case "g1-pro-tier": return "crown.fill"
        case "standard-tier": return "star.fill"
        default: return "person.fill"
        }
    }
    
    private var paidTierColor: Color {
        guard let paidTier = info.paidTier else { return .purple }
        switch paidTier.id {
        case "g1-pro-tier": return .purple
        case "g1-ultra-tier": return .orange
        default: return .purple
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                HStack(spacing: 6) {
                    Image(systemName: tierIcon)
                        .font(.subheadline)
                    Text(info.tierDisplayName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(tierColor.opacity(0.15))
                .foregroundStyle(tierColor)
                .clipShape(Capsule())
                
                if let project = info.cloudaicompanionProject {
                    HStack(spacing: 4) {
                        Image(systemName: "folder.fill")
                            .font(.caption)
                        Text(project)
                            .font(.subheadline)
                    }
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                }
                
                Spacer()
            }
            
            if let paidTier = info.paidTier, let upgradeUri = paidTier.upgradeSubscriptionUri, let url = URL(string: upgradeUri) {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 6) {
                            Image(systemName: "crown.fill")
                                .font(.subheadline)
                            Text(paidTier.name)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(paidTierColor)
                        
                        if let upgradeText = paidTier.upgradeSubscriptionText {
                            Text(upgradeText)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(3)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                    Spacer()
                    
                    Link(destination: url) {
                        Label("subscription.upgrade".localized(), systemImage: "arrow.up.circle.fill")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(paidTierColor)
                }
                .padding(14)
                .background(paidTierColor.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

private struct ModelQuotaRow: View {
    let model: ModelQuota
    
    private var remainingPercent: Double {
        model.percentage
    }
    
    private var tint: Color {
        if remainingPercent > 50 { return .green }
        if remainingPercent > 20 { return .orange }
        return .red
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(model.displayName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Text(model.formattedPercentage)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(tint)
                    
                    if model.formattedResetTime != "—" {
                        HStack(spacing: 4) {
                            Image(systemName: "clock.fill")
                                .font(.caption)
                            Text(model.formattedResetTime)
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.quaternary)
                        .clipShape(Capsule())
                    }
                }
            }
            
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.quaternary)
                    Capsule()
                        .fill(tint.gradient)
                        .frame(width: proxy.size.width * min(1, remainingPercent / 100))
                }
            }
            .frame(height: 10)
        }
    }
}

private struct SummaryCard: View {
    let totalReady: Int
    let totalAccounts: Int
    let providerCount: Int
    
    private var readyPercent: Double {
        guard totalAccounts > 0 else { return 0 }
        return Double(totalReady) / Double(totalAccounts) * 100
    }
    
    var body: some View {
        GroupBox {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("quota.overallStatus".localized())
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("\(providerCount) " + "quota.providers".localized() + ", \(totalAccounts) " + "quota.accounts".localized())
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("\(totalReady)/\(totalAccounts)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(totalReady > 0 ? .green : .secondary)
                        Text("status.ready".localized())
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                QuotaProgressBar(
                    percent: readyPercent,
                    tint: readyPercent >= 75 ? .green : (readyPercent >= 50 ? .orange : .red),
                    height: 14
                )
                
                Text("\(Int(readyPercent))% " + "quota.accountsReady".localized())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(12)
        }
    }
}

private struct SubscriptionSkeletonView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.quaternary)
                    .frame(width: 120, height: 32)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(.quaternary)
                    .frame(width: 100, height: 16)
                
                Spacer()
            }
            
            RoundedRectangle(cornerRadius: 12)
                .fill(.quaternary)
                .frame(height: 80)
        }
        .opacity(isAnimating ? 0.5 : 1.0)
        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isAnimating)
        .onAppear { isAnimating = true }
    }
}

private struct QuotaSkeletonView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 16) {
            Divider()
                .padding(.vertical, 4)
            
            ForEach(0..<3, id: \.self) { _ in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.quaternary)
                            .frame(width: 100, height: 16)
                        
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.quaternary)
                            .frame(width: 40, height: 16)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.quaternary)
                            .frame(width: 60, height: 24)
                    }
                    
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.quaternary)
                        .frame(height: 10)
                }
            }
        }
        .opacity(isAnimating ? 0.5 : 1.0)
        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isAnimating)
        .onAppear { isAnimating = true }
    }
}

#Preview {
    QuotaScreen()
        .environment(QuotaViewModel())
        .frame(width: 700, height: 600)
}
