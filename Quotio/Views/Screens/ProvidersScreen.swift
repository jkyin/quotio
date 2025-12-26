//
//  ProvidersScreen.swift
//  Quotio
//

import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct ProvidersScreen: View {
    @Environment(QuotaViewModel.self) private var viewModel
    @State private var isImporterPresented = false
    @State private var selectedProvider: AIProvider?
    @State private var projectId: String = ""
    
    var body: some View {
        List {
            if !viewModel.proxyManager.proxyStatus.running {
                Section {
                    ContentUnavailableView {
                        Label("empty.proxyNotRunning".localized(), systemImage: "exclamationmark.triangle")
                    } description: {
                        Text("providers.startProxyFirst".localized())
                    }
                }
            } else {
                // Connected Accounts
                Section {
                    if viewModel.authFiles.isEmpty {
                        Text("providers.noAccountsYet".localized())
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(viewModel.authFiles, id: \.id) { file in
                            AuthFileRow(file: file) {
                                Task { await viewModel.deleteAuthFile(file) }
                            }
                            .contextMenu {
                                Button(role: .destructive) {
                                    Task { await viewModel.deleteAuthFile(file) }
                                } label: {
                                    Label("action.delete".localized(), systemImage: "trash")
                                }
                            }
                        }
                    }
                } header: {
                    Label("providers.connectedAccounts".localized() + " (\(viewModel.authFiles.count))", systemImage: "checkmark.seal.fill")
                }
                
                // Add Provider
                Section {
                    ForEach(AIProvider.allCases) { provider in
                    Button {
                        if provider == .vertex {
                            isImporterPresented = true
                        } else {
                            viewModel.oauthState = nil
                            selectedProvider = provider
                        }
                    } label: {
                            HStack {
                                ProviderIcon(provider: provider, size: 24)
                                
                                Text(provider.displayName)
                                
                                Spacer()
                                
                                if let count = viewModel.authFilesByProvider[provider]?.count, count > 0 {
                                    Text("\(count)")
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 2)
                                        .background(provider.color.opacity(0.15))
                                        .foregroundStyle(provider.color)
                                        .clipShape(Capsule())
                                }
                                
                                Image(systemName: "plus.circle")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                } header: {
                    Label("providers.addProvider".localized(), systemImage: "plus.circle.fill")
                }
            }
        }
        .navigationTitle("nav.providers".localized())
        .sheet(item: $selectedProvider) { provider in
            OAuthSheet(provider: provider, projectId: $projectId) {
                selectedProvider = nil
                projectId = ""
                viewModel.oauthState = nil
            }
            .environment(viewModel)
        }
        .fileImporter(
            isPresented: $isImporterPresented,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    Task {
                        await viewModel.importVertexServiceAccount(url: url)
                    }
                }
            case .failure(let error):
                print("Import failed: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Auth File Row

struct AuthFileRow: View {
    let file: AuthFile
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            if let provider = file.providerType {
                ProviderIcon(provider: provider, size: 24)
            } else {
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(file.email ?? file.name)
                    .fontWeight(.medium)
                
                HStack(spacing: 6) {
                    Text(file.providerType?.displayName ?? "[\(file.provider)]")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Circle()
                        .fill(file.statusColor)
                        .frame(width: 6, height: 6)
                    
                    Text(file.status)
                        .font(.caption)
                        .foregroundStyle(file.statusColor)
                }
            }
            
            Spacer()
            
            if file.disabled {
                Text("providers.disabled".localized())
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.secondary.opacity(0.2))
                    .clipShape(Capsule())
            }
            
            Button(role: .destructive) {
                onDelete()
            } label: {
                Image(systemName: "trash")
                    .foregroundStyle(.red)
            }
            .buttonStyle(.borderless)
            .help("action.delete".localized())
        }
    }
}

// MARK: - OAuth Sheet

struct OAuthSheet: View {
    @Environment(QuotaViewModel.self) private var viewModel
    let provider: AIProvider
    @Binding var projectId: String
    let onDismiss: () -> Void
    
    @State private var hasStartedAuth = false
    @State private var selectedKiroMethod: AuthCommand = .kiroGoogleLogin
    
    private var isPolling: Bool {
        viewModel.oauthState?.status == .polling || viewModel.oauthState?.status == .waiting
    }
    
    private var isSuccess: Bool {
        viewModel.oauthState?.status == .success
    }
    
    private var isError: Bool {
        viewModel.oauthState?.status == .error
    }
    
    private var kiroAuthMethods: [AuthCommand] {
        [.kiroGoogleLogin, .kiroAWSAuthCode, .kiroAWSLogin, .kiroImport]
    }
    
    var body: some View {
        VStack(spacing: 28) {
            ProviderIcon(provider: provider, size: 64)
            
            VStack(spacing: 8) {
                Text("oauth.connect".localized() + " " + provider.displayName)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("oauth.authenticateWith".localized() + " " + provider.displayName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            if provider == .gemini {
                VStack(alignment: .leading, spacing: 6) {
                    Text("oauth.projectId".localized())
                        .font(.subheadline)
                        .fontWeight(.medium)
                    TextField("oauth.projectIdPlaceholder".localized(), text: $projectId)
                        .textFieldStyle(.roundedBorder)
                }
                .frame(maxWidth: 320)
            }
            
            if provider == .kiro {
                VStack(alignment: .leading, spacing: 6) {
                    Text("oauth.authMethod".localized())
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Picker("", selection: $selectedKiroMethod) {
                        ForEach(kiroAuthMethods, id: \.self) { method in
                            Text(method.displayName).tag(method)
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                }
                .frame(maxWidth: 320)
            }
            
            if let state = viewModel.oauthState, state.provider == provider {
                OAuthStatusView(status: state.status, error: state.error, state: state.state, provider: provider)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
            
            HStack(spacing: 16) {
                Button("action.cancel".localized(), role: .cancel) {
                    viewModel.cancelOAuth()
                    onDismiss()
                }
                .buttonStyle(.bordered)
                
                if isError {
                    Button {
                        hasStartedAuth = false
                        Task {
                            await viewModel.startOAuth(for: provider, projectId: projectId.isEmpty ? nil : projectId, authMethod: provider == .kiro ? selectedKiroMethod : nil)
                        }
                    } label: {
                        Label("oauth.retry".localized(), systemImage: "arrow.clockwise")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                } else if !isSuccess {
                    Button {
                        hasStartedAuth = true
                        Task {
                            await viewModel.startOAuth(for: provider, projectId: projectId.isEmpty ? nil : projectId, authMethod: provider == .kiro ? selectedKiroMethod : nil)
                        }
                    } label: {
                        if isPolling {
                            ProgressView()
                                .controlSize(.small)
                        } else {
                            Label("oauth.authenticate".localized(), systemImage: "key.fill")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(provider.color)
                    .disabled(isPolling)
                }
            }
        }
        .padding(40)
        .frame(width: 480, height: 400)
        .animation(.easeInOut(duration: 0.2), value: viewModel.oauthState?.status)
        .onChange(of: viewModel.oauthState?.status) { _, newStatus in
            if newStatus == .success {
                Task {
                    try? await Task.sleep(nanoseconds: 1_500_000_000)
                    onDismiss()
                }
            }
        }
    }
}

private struct OAuthStatusView: View {
    let status: OAuthState.OAuthStatus
    let error: String?
    let state: String?
    let provider: AIProvider
    
    var body: some View {
        Group {
            switch status {
            case .waiting:
                VStack(spacing: 12) {
                    ProgressView()
                        .controlSize(.large)
                    Text("oauth.openingBrowser".localized())
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 16)
                
            case .polling:
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .stroke(provider.color.opacity(0.2), lineWidth: 4)
                            .frame(width: 60, height: 60)
                        
                        Circle()
                            .trim(from: 0, to: 0.7)
                            .stroke(provider.color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                            .frame(width: 60, height: 60)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: UUID())
                        
                        Image(systemName: "person.badge.key.fill")
                            .font(.title2)
                            .foregroundStyle(provider.color)
                    }
                    
                    // For Copilot Device Code flow, show device code with copy button
                    if provider == .copilot, let deviceCode = state, !deviceCode.isEmpty {
                        VStack(spacing: 8) {
                            Text("oauth.enterCodeInBrowser".localized())
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            HStack(spacing: 12) {
                                Text(deviceCode)
                                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                                    .foregroundStyle(provider.color)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(provider.color.opacity(0.1))
                                    .cornerRadius(8)
                                
                                Button {
                                    NSPasteboard.general.clearContents()
                                    NSPasteboard.general.setString(deviceCode, forType: .string)
                                } label: {
                                    Image(systemName: "doc.on.doc")
                                        .font(.title3)
                                }
                                .buttonStyle(.borderless)
                                .help("action.copyCode".localized())
                            }
                            
                            Text("oauth.waitingForAuth".localized())
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } else if provider == .copilot, let message = error {
                        Text(message)
                            .font(.caption)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 350)
                    } else {
                        Text("oauth.waitingForAuth".localized())
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text("oauth.completeBrowser".localized())
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 16)
                
            case .success:
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.green)
                    
                    Text("oauth.success".localized())
                        .font(.headline)
                        .foregroundStyle(.green)
                    
                    Text("oauth.closingSheet".localized())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 16)
                
            case .error:
                VStack(spacing: 12) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.red)
                    
                    Text("oauth.failed".localized())
                        .font(.headline)
                        .foregroundStyle(.red)
                    
                    if let error = error {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 300)
                    }
                }
                .padding(.vertical, 16)
            }
        }
        .frame(height: 120)
    }
}
