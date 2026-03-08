# AI Autonomous RWA Vehicle Protocol

AI‑driven cross‑chain protocol for autonomous real‑world vehicle NFTs.

---

## 📖 About

**AI Autonomous RWA Vehicle Protocol** is a decentralized application that tokenizes real‑world vehicles as NFTs and manages them across multiple blockchains using Chainlink’s Runtime Environment (CRE). It combines smart contracts, a frontend dashboard, and automated workflows to enable secure, compliant, and autonomous asset transfers.

### 🔧 How It Works

- **Minting**: Users connect their wallet and mint a Car NFT representing a real‑world vehicle.
- **Locking & Transfer**: When a vehicle NFT is locked, Chainlink CRE listens for the event and orchestrates a cross‑chain transfer using CCIP.
- **Unlocking**: The NFT is unlocked on the destination chain, with ownership updated automatically.
- **Automation**: CRE workflows can include off‑chain API checks (e.g., registration, compliance) before executing transfers.
- **User Dashboard**: A Next.js frontend provides wallet connection, balance tracking, event logs, and real‑time notifications.

### 🧩 Problem It Solves

Managing **real‑world assets (RWAs)** like vehicles across chains is complex and error‑prone. This protocol solves that by:

- Automating cross‑chain transfers with Chainlink CCIP.
- Enforcing compliance via off‑chain API checks.
- Providing transparency through event logs and on‑chain proofs.
- Delivering a user‑friendly dashboard for seamless interaction.

### ✨ Key Features

- AI‑driven decision logic for autonomous workflows.
- Cross‑chain interoperability (Sepolia, Fuji, and beyond).
- Secure minting, locking, and unlocking of vehicle NFTs.
- Real‑time feedback via toast notifications and status panels.
- Extensible design for integrating compliance or telemetry APIs.

---

## Structure

### ai-autonomous-rwa-vehicle-protocol/

│
├── contracts/ # Solidity smart contracts for Car NFT minting, locking, and cross-chain logic
│ └── CarNFT.sol # Example contract defining vehicle NFT behavior
│
├── frontend/ # Next.js/React frontend for user interaction
│ ├── components/ # UI panels (MintPanel, LockPanel, UnlockPanel, StatusPanel)
│ ├── pages/ # App routes and main dashboard
│ └── utils/ # Helper functions (validateLock, listenForUnlockEvents, etc.)
│
├── my-workflow/ # Chainlink CRE workflows
│ ├── main.ts # Workflow entry point (event triggers, API checks, contract calls)
│ └── staging-settings.json # Chain configuration (RPCs, chain IDs, contract addresses, selectors)
│
├── scripts/ # Deployment and utility scripts
│ └── deploy.ts # Example script for deploying contracts
│
├── .env.local # Environment variables (wrapper addresses, chain selectors, API URLs)
├── package.json # Project dependencies and scripts
└── README.md # Documentation

## 🚀 Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/7gbice/ai-autonomous-rwa-vehicle-protocol.git
cd ai-autonomous-rwa-vehicle-protocol

bun install
cd frontend
npm install
bun dev
```

## ⚠️ Challenges Encountered

Building this protocol came with several hurdles:

- **SDK Changes**  
  The Chainlink CRE SDK evolved during development, and some classes (`EvmEventCapability`, `HttpCapability`, `EvmCapability`) were deprecated. This caused compilation errors until imports were updated to the current API (`EvmEvent`, `Http`, `Evm`).

- **RPC Reliability**  
  Public RPC endpoints (like Sepolia’s publicnode) often timed out or failed health checks. Switching to Infura/Alchemy RPCs solved stability issues and ensured workflows could compile and run.

- **Contract Reverts**  
  Early tests triggered `require(false)` reverts because of mismatched token IDs, ownership checks, or missing approvals. Adding validation helpers (`validateLock`) and ensuring correct addresses fixed these issues.

- **Configuration Management**  
  Hardcoding chain IDs and addresses made workflows brittle. Moving these into `staging-settings.json` improved flexibility and reduced errors.

- **Cross‑Chain Complexity**  
  Coordinating events across Sepolia and Fuji required careful setup of CCIP selectors and contract addresses, plus monitoring unlock events to keep the frontend in sync.

---

These challenges highlight the importance of **keeping up with SDK changes**, **using reliable RPC providers**, and **centralizing configuration** for multi‑chain workflows.
