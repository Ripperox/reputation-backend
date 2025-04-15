# 📖 Reputation System Smart Contract

A Solidity-based smart contract backend for managing wallet reputation scores on the Ethereum **Sepolia Testnet**, with optional **Soulbound Token (SBT)** minting for high-reputation addresses. Built using **Hardhat Ignition** for deployment.

---

## 🚀 Features

✅ Assigns reputation scores to wallet addresses  
✅ Updates reputation based on predefined actions (example: voting in DAO, completing a task, or verification)  
✅ Optionally mints a **Soulbound Token (SBT)** when a reputation threshold is reached  
✅ Deployable to the **Ethereum Sepolia testnet**

---

## 🛠 Tech Stack

- **Solidity** (v0.8.x)
- **Hardhat** (with **Hardhat Ignition** for deployment scripting)
- **OpenZeppelin Contracts** (ERC721, ERC721Enumerable, ERC721URIStorage, Ownable)
- **Sepolia Testnet** (Ethereum test network)

---

## 📄 Smart Contract Overview

The `ReputationSystem` smart contract:
- Maps Ethereum wallet addresses to **reputation scores**.
- Provides functions for the **owner** to increase a wallet’s reputation.
- **Automatically mints an SBT** for users crossing a threshold reputation score (default: `100`).
- Utilizes ERC721-compatible Soulbound Tokens (non-transferable tokens with unique metadata) stored on **IPFS**.

---

## 📦 Installation & Setup

```bash
# Install dependencies
npm install

# Compile contracts
npx hardhat compile
```


## Deployment (Sepolia Testnet)
This project uses Hardhat Ignition for deployment automation.

1️⃣ Configure your .env
```bash
SEPOLIA_RPC_URL=YOUR_SEPOLIA_RPC_URL
PRIVATE_KEY=YOUR_DEPLOYER_WALLET_PRIVATE_KEY
```
2️⃣ Deploy the contract
```bash
npx hardhat ignition deploy ignition/modules/ReputationSystem.js --network sepolia
```
