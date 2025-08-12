# Fund Me Dapp (Sepolia)

This project is a full-stack decentralized application (dapp) for crowdfunding using Ethereum smart contracts. It leverages [Foundry](https://book.getfoundry.sh/) for Solidity development, testing, and deployment, and includes a minimalistic HTML/JavaScript frontend for interacting with the contract.

## Overview

- **Smart Contract:** `FundMe.sol` allows users to fund the contract with ETH, tracks funders, and enables the owner to withdraw funds. It uses Chainlink price feeds to enforce a minimum funding amount in USD.
- **Frontend:** Located in `html-crypto-fund-me/`, the frontend lets users connect their wallet (e.g., MetaMask), fund the contract, and view contract status.
- **Deployment:** The contract is deployed on the Sepolia Ethereum testnet.

## 🚀 Live Sepolia Contract

- **FundMe Contract Address:** [`0xb4C2B2535B12598e4832A0797874B30739Ad0F94`](https://sepolia.etherscan.io/address/0xb4C2B2535B12598e4832A0797874B30739Ad0F94)
- **Network:** Sepolia Testnet

You can interact with this contract using the provided frontend or directly via Etherscan.

## Quick Start

### 1. Build & Test Contracts

```bash
forge build
forge test
```

### 2. Deploy to Sepolia

Set your environment variables in a `.env` file (see Makefile for required variables), then:

```bash
make deploy-sepolia
```

### 3. Frontend Usage

Open `html-crypto-fund-me/index.html` in your browser. Connect your wallet (MetaMask, Sepolia network), and interact with the contract at `0xb4C2B2535B12598e4832A0797874B30739Ad0F94`.

## Project Structure

- `src/` — Solidity contracts (main: `FundMe.sol`)
- `script/` — Deployment and interaction scripts
- `test/` — Foundry tests
- `html-crypto-fund-me/` — Frontend (HTML/JS)
- `Makefile` — Build, test, and deploy automation

## Foundry Toolkit

- **Forge:** Testing framework
- **Cast:** CLI for contract interaction
- **Anvil:** Local Ethereum node

See [Foundry Book](https://book.getfoundry.sh/) for full documentation.

---

**Demo Contract:** [0xb4C2B2535B12598e4832A0797874B30739Ad0F94](https://sepolia.etherscan.io/address/0xb4C2B2535B12598e4832A0797874B30739Ad0F94) (Sepolia)
