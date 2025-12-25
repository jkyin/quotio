# Quotio

![Quotio Banner](screenshots/dashboard.png)

<p align="center">
  <img src="https://img.shields.io/badge/platform-macOS-lightgrey.svg?style=flat" alt="Platform macOS" />
  <img src="https://img.shields.io/badge/language-Swift-orange.svg?style=flat" alt="Language Swift" />
  <img src="https://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License MIT" />
  <a href="README.vi.md"><img src="https://img.shields.io/badge/lang-Tiếng%20Việt-red.svg?style=flat" alt="Vietnamese" /></a>
</p>

<p align="center">
  <strong>The ultimate command center for your AI coding assistants on macOS.</strong>
</p>

Quotio is a native macOS application for managing **CLIProxyAPI** - a local proxy server that powers your AI coding agents. It helps you manage multiple AI accounts, track quotas, and configure CLI tools in one place.

## ✨ Features

- **🔌 Multi-Provider Support**: Connect accounts from Gemini, Claude, OpenAI, Qwen, Vertex AI, iFlow, and Antigravity via OAuth or API keys.
- **🚀 One-Click Agent Configuration**: Auto-detect and configure AI coding tools like Claude Code, OpenCode, Gemini CLI, and more.
- **📊 Real-time Dashboard**: Monitor request traffic, token usage, and success rates live.
- **📉 Smart Quota Management**: Visual quota tracking per account with automatic failover strategies (Round Robin / Fill First).
- **🔑 API Key Management**: Generate and manage API keys for your local proxy.
- **🖥️ Menu Bar Integration**: Quick access to server status and controls from your menu bar.
- **🔔 Notifications**: Alerts for low quotas, account cooling periods, or service issues.
- **🌍 Bilingual**: English and Vietnamese support.

## 📸 Screenshots

| Dashboard | Providers |
|:---:|:---:|
| ![Dashboard](screenshots/dashboard.png) | ![Providers](screenshots/providers.png) |
| **Agent Setup** | **Quota Monitoring** |
| ![Agent Setup](screenshots/agent_setup.png) | ![Quota Monitoring](screenshots/quota.png) |
| **Menu Bar** | |
| ![Menu Bar](screenshots/menu_bar.png) | |

## 🤖 Supported Ecosystem

### AI Providers
| Provider | Auth Method |
|----------|-------------|
| Google Gemini | OAuth |
| Anthropic Claude | OAuth |
| OpenAI Codex | OAuth |
| Qwen Code | OAuth |
| Vertex AI | Service Account JSON |
| iFlow | OAuth |
| Antigravity | OAuth |

### Compatible CLI Agents
Quotio can automatically configure these tools to use your centralized proxy:
- Claude Code
- Codex CLI
- Gemini CLI
- Amp CLI
- OpenCode
- Factory Droid

## 🚀 Installation

### Requirements
- macOS 15.0 (Sequoia) or later
- Internet connection for OAuth authentication

### Building from Source

1. **Clone the repository:**
   ```bash
   git clone https://github.com/user/Quotio.git
   cd Quotio
   ```

2. **Open in Xcode:**
   ```bash
   open Quotio.xcodeproj
   ```

3. **Build and Run:**
   - Select the "Quotio" scheme
   - Press `Cmd + R` to build and run

> The app will automatically download the `CLIProxyAPI` binary on first launch.

## 📖 Usage

### 1. Start the Server
Launch Quotio and click **Start** on the dashboard to initialize the local proxy server.

### 2. Connect Accounts
Go to **Providers** tab → Click on a provider → Authenticate via OAuth or import credentials.

### 3. Configure Agents
Go to **Agents** tab → Select an installed agent → Click **Configure** → Choose Automatic or Manual mode.

### 4. Monitor Usage
- **Dashboard**: Overall health and traffic
- **Quota**: Per-account usage breakdown
- **Logs**: Raw request/response logs for debugging

## ⚙️ Settings

- **Port**: Change the proxy listening port
- **Routing Strategy**: Round Robin or Fill First
- **Auto-start**: Launch proxy automatically when Quotio opens
- **Notifications**: Toggle alerts for various events

## 🤝 Contributing

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/amazing-feature`)
3. Commit your Changes (`git commit -m 'Add amazing feature'`)
4. Push to the Branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

MIT License. See `LICENSE` for details.
