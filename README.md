# FanCup Stacks 2026
![Stacks](https://img.shields.io/badge/Network-Stacks-5546FF?style=for-the-badge&logo=stacks)
![Clarity](https://img.shields.io/badge/Smart%20Contracts-Clarity-black?style=for-the-badge)
![React](https://img.shields.io/badge/Frontend-React-61DAFB?style=for-the-badge&logo=react)
![Vite](https://img.shields.io/badge/Build-Vite-646CFF?style=for-the-badge&logo=vite)
![TailwindCSS](https://img.shields.io/badge/UI-TailwindCSS-38B2AC?style=for-the-badge&logo=tailwindcss)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**FanCup Stacks 2026** is an onchain football prediction and fan voting arena built on **Stacks**, using **Clarity smart contracts**, **Clarinet**, **Stacks Connect**, and **Stacks.js**.

Fans can join a tournament, choose their favorite team, submit match predictions, check in daily, earn non-transferable fan points, boost teams, and build an onchain supporter reputation.

This project is built for the **Stacks ecosystem** and designed as a real consumer-facing dApp that demonstrates recurring onchain interaction, smart contract activity, and Bitcoin L2 application development.

---

## Built for Stacks

Stacks is a Bitcoin L2 for smart contracts, apps, and DeFi. The official Stacks documentation positions Stacks as a network for building Bitcoin-secured apps, with developer paths covering Clarity, Clarinet, Stacks.js, Stacks Connect, contract calls, and transaction broadcasting.

FanCup Stacks 2026 uses:

* **Stacks blockchain**
* **Clarity smart contracts**
* **Clarinet contract tooling**
* **Stacks Connect wallet integration**
* **Stacks.js transaction calls**
* **STX-compatible contract interaction**
* **Next.js frontend**
* **TypeScript**
* **TailwindCSS**

---

## Talent Protocol / Stacks Builder Rewards Alignment

This repository is structured to be clearly recognized as a **Stacks ecosystem project**.

The project includes:

* Clarity contracts in `/contracts`
* Clarinet configuration
* Next.js frontend
* Stacks wallet connection
* Stacks contract call UI
* README documentation
* Stacks ecosystem keywords
* Mainnet-ready contract architecture
* User-facing dApp flow
* Onchain activity design

Talent Protocol's Stacks Builder Rewards flow requires builders to add a project, verify its website, and add a Stacks smart contract to the verified project. FanCup Stacks 2026 is structured around that flow.

---

## Project Summary

**FanCup Stacks 2026** is not a betting app and does not use gambling mechanics.

It is a fan prediction and reputation game where users interact with Clarity smart contracts to:

* Join the FanCup tournament
* Choose a supporter team
* Predict match winners
* Predict exact scores
* Check in daily
* Claim fan points
* Boost teams using earned points
* Mint supporter badges
* Build onchain fan reputation

All game points are non-transferable reputation points used inside the application.

---

## Core Idea

Football fans already vote, predict, debate, and support teams every day.

FanCup brings that behavior onchain through Stacks:

> Join. Predict. Check in. Earn fan points. Boost your team. Build your supporter reputation on Bitcoin L2.

The goal is to create a fun, repeatable, non-financial, consumer-friendly dApp that produces natural onchain activity.

---

## Why This Matters

Most prediction games are either offchain, centralized, or tied to gambling mechanics.

FanCup Stacks 2026 takes a different approach:

* No betting pool
* No odds
* No wagering
* No custody of user funds
* No gambling reward loop
* Reputation-first fan activity
* Transparent onchain participation
* Simple UX for new Stacks users

This makes it safer, easier to understand, and more aligned with community participation.

---

## Onchain Activity Engine

FanCup is designed around repeatable onchain actions.

### User Actions

| Action               | Contract Function    | Onchain TX |
| -------------------- | -------------------- | ---------- |
| Join tournament      | `join-tournament`    | Yes        |
| Choose favorite team | `choose-team`        | Yes        |
| Predict match winner | `predict-winner`     | Yes        |
| Predict exact score  | `predict-score`      | Yes        |
| Daily check-in       | `daily-checkin`      | Yes        |
| Claim winner points  | `claim-points`       | Yes        |
| Claim score points   | `claim-score-points` | Yes        |
| Boost team           | `boost-team`         | Yes        |

### Admin / Keeper Actions

| Action             | Contract Function  | Onchain TX |
| ------------------ | ------------------ | ---------- |
| Create match       | `create-match`     | Yes        |
| Set match result   | `set-match-result` | Yes        |
| Pause contract     | `set-paused`       | Yes        |
| Add operator/admin | `set-admin`        | Yes        |

### Badge Actions

| Action                | Contract Function       | Onchain TX |
| --------------------- | ----------------------- | ---------- |
| Mint supporter card   | `mint-supporter-card`   | Yes        |
| Mint streak badge     | `mint-streak-badge`     | Yes        |
| Mint prediction badge | `mint-prediction-badge` | Yes        |

---

## Smart Contracts

The project currently includes two Clarity smart contracts:

```txt
contracts/
├── fancup-core.clar
└── fancup-badge.clar
```

---

## Contract 1: `fancup-core.clar`

The core contract handles the main prediction and fan activity logic.

### Main Features

* Tournament registration
* Team selection
* Match creation
* Winner prediction
* Score prediction
* Daily check-in
* Result finalization
* Fan point claiming
* Team boosting
* Admin role management
* Pause control
* Ownership transfer

### Core Public Functions

```clarity
(join-tournament)
(choose-team (team-id uint))
(create-match (team-a uint) (team-b uint) (start-block uint) (close-block uint))
(predict-winner (match-id uint) (pick uint))
(predict-score (match-id uint) (score-a uint) (score-b uint))
(daily-checkin)
(set-match-result (match-id uint) (score-a uint) (score-b uint))
(claim-points (match-id uint))
(claim-score-points (match-id uint))
(boost-team (team-id uint) (amount uint))
(set-admin (admin principal) (enabled bool))
(set-paused (value bool))
(transfer-ownership (new-owner principal))
```

### Read-Only Functions

```clarity
(get-player (user principal))
(get-match (match-id uint))
(get-team-boost (team-id uint))
(has-predicted-winner (user principal) (match-id uint))
(get-winner-prediction (user principal) (match-id uint))
(get-score-prediction (user principal) (match-id uint))
(get-owner)
(get-total-players)
(get-next-match-id)
(is-paused)
(is-admin-address (admin principal))
```

---

## Contract 2: `fancup-badge.clar`

The badge contract handles NFT-style supporter and achievement badges.

### Badge Types

| Badge Type   | Meaning                          |
| ------------ | -------------------------------- |
| `u1` - `u64` | Supporter cards based on team ID |
| `u1000`      | Streak badge                     |
| `u2000`      | Prediction badge                 |

### Badge Functions

```clarity
(mint-supporter-card (recipient principal) (team-id uint))
(mint-streak-badge (recipient principal))
(mint-prediction-badge (recipient principal))
(set-minter (minter principal) (enabled bool))
(transfer-ownership (new-owner principal))
```

### Badge Read-Only Functions

```clarity
(get-contract-owner)
(get-last-token-id)
(get-owner (token-id uint))
(get-badge-metadata (token-id uint))
(has-badge (user principal) (badge-type uint))
(is-approved-minter (minter principal))
```

---

## Frontend

The frontend is built with:

* Next.js
* TypeScript
* TailwindCSS
* Stacks Connect
* Stacks transactions

Current UI includes:

* Connect Wallet
* Contract address display
* Join Tournament button
* Choose Team form
* Daily Check-in button
* Predict Winner form
* Predict Score form
* Claim Winner Points button
* Claim Score Points button
* Boost Team form

---

## Repository Structure

```txt
fancup-stacks-2026/
├── app/
│   ├── globals.css
│   ├── layout.tsx
│   └── page.tsx
├── components/
│   ├── ClientOnlyFanCup.tsx
│   └── FanCupApp.tsx
├── contracts/
│   ├── fancup-core.clar
│   └── fancup-badge.clar
├── lib/
│   └── stacks.ts
├── settings/
├── tests/
├── Clarinet.toml
├── package.json
├── package-lock.json
├── postcss.config.mjs
├── next.config.ts
├── tsconfig.json
└── README.md
```

---

## Tech Stack

| Layer                   | Technology     |
| ----------------------- | -------------- |
| Blockchain              | Stacks         |
| Smart Contract Language | Clarity        |
| Contract Tooling        | Clarinet       |
| Frontend                | Next.js        |
| UI                      | TailwindCSS    |
| Wallet                  | Stacks Connect |
| Transactions            | Stacks.js      |
| Language                | TypeScript     |
| Deployment              | Vercel         |
| Network Target          | Stacks Mainnet |

---

## Stacks Ecosystem Keywords

This project is related to:

```txt
stacks
stx
clarity
clarinet
stacks-connect
stacks-js
bitcoin-l2
bitcoin-layer-2
smart-contracts
onchain
dapp
web3
fan-voting
prediction-game
onchain-game
consumer-crypto
```

---

## GitHub Topics Recommendation

Recommended GitHub repository topics:

```txt
stacks
clarity
stx
clarinet
stacks-connect
stacks-js
bitcoin-l2
bitcoin-layer-2
smart-contracts
dapp
onchain-game
prediction-game
fan-voting
nextjs
typescript
tailwindcss
```

---

## Local Development

### 1. Clone the Repository

```bash
git clone git@github.com:amandaaaaaaew23/fancup-stacks-2026.git
cd fancup-stacks-2026
```

### 2. Install Dependencies

```bash
npm install
```

### 3. Check Clarity Contracts

```bash
clarinet check
```

Expected result:

```txt
✔ 2 contracts checked
```

Warnings may appear from Clarinet analysis, but the contracts should compile successfully with zero fatal errors.

### 4. Run Frontend

```bash
npm run dev
```

Open:

```txt
http://localhost:3000
```

### 5. Build Frontend

```bash
npm run build
```

---

## Environment Variables

Create `.env.local`:

```env
NEXT_PUBLIC_CONTRACT_ADDRESS=SPXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
NEXT_PUBLIC_CORE_CONTRACT=fancup-core
NEXT_PUBLIC_BADGE_CONTRACT=fancup-badge
```

Before mainnet deployment, a placeholder contract address can be used only for frontend build testing.

After mainnet deployment, replace `NEXT_PUBLIC_CONTRACT_ADDRESS` with the actual Stacks deployer address.

---

## Mainnet Deployment Plan

Target network:

```txt
Stacks Mainnet
```

Planned deployed contracts:

```txt
SPXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.fancup-core
SPXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.fancup-badge
```

Deployment steps:

```bash
clarinet check
clarinet deployments generate --mainnet
clarinet deployments apply --mainnet
```

After deployment:

1. Update `.env.local`
2. Update Vercel environment variables
3. Update README contract addresses
4. Add deployed Stacks smart contracts to Talent Protocol project
5. Verify website on Talent Protocol
6. Continue shipping commits and onchain activity

---

## Mainnet Contract Addresses

Current status:

```txt
Status: Not deployed yet
Network: Stacks Mainnet planned
```

Update this section after deployment:

```txt
Core Contract:
SP6Y22GYPXRM900PC0W9ZC3D292PH2P1ZKQ5RQAT.fancup-core

Badge Contract:
SP6Y22GYPXRM900PC0W9ZC3D292PH2P1ZKQ5RQAT.fancup-badge
```

---

## User Flow

### 1. Connect Wallet

User connects a Stacks wallet using Stacks Connect.

### 2. Join Tournament

User calls:

```clarity
(join-tournament)
```

This creates an onchain FanCup profile.

### 3. Choose Team

User calls:

```clarity
(choose-team u1)
```

Example team IDs:

| ID   | Team      |
| ---- | --------- |
| `u1` | Brazil    |
| `u2` | Argentina |
| `u3` | France    |
| `u4` | England   |
| `u5` | Japan     |
| `u6` | Portugal  |
| `u7` | Spain     |
| `u8` | Germany   |

### 4. Predict Match

User predicts match winner:

```clarity
(predict-winner u1 u1)
```

Pick values:

| Pick | Meaning     |
| ---- | ----------- |
| `u0` | Draw        |
| `u1` | Team A wins |
| `u2` | Team B wins |

User predicts exact score:

```clarity
(predict-score u1 u2 u1)
```

### 5. Daily Check-in

User calls:

```clarity
(daily-checkin)
```

This increases user streak and gives fan points.

### 6. Claim Points

After match result is set, user can claim points:

```clarity
(claim-points u1)
(claim-score-points u1)
```

### 7. Boost Team

User spends fan points to boost a team:

```clarity
(boost-team u1 u5)
```

---

## Points System

| Activity                  | Points |
| ------------------------- | ------ |
| Daily check-in            | `+1`   |
| Correct winner prediction | `+10`  |
| Exact score prediction    | `+30`  |

Points are non-transferable and used only inside the FanCup reputation system.

---

## Security Notes

The current MVP includes:

* Owner control
* Admin role management
* Pause switch
* One winner prediction per wallet per match
* One score prediction per wallet per match
* Match close block
* Result finalization by admin
* Score bounds
* Team ID bounds
* Non-transferable point accounting
* No custody of user funds
* No betting pool
* No odds
* No wagering mechanics

---

## Non-Gambling Design

FanCup Stacks 2026 is designed as a fan reputation and prediction game.

It does not include:

* Betting
* Gambling
* Wagering
* Odds
* User-funded prize pools
* Payouts based on deposited funds

The core loop is:

```txt
Predict → Check in → Earn reputation points → Boost team → Build supporter profile
```

---

## Roadmap

### Phase 1 — MVP

* Clarity core contract
* Badge contract
* Clarinet validation
* Next.js frontend
* Stacks Connect integration
* Contract call UI
* GitHub repository
* Vercel deployment

### Phase 2 — Mainnet Launch

* Deploy `fancup-core.clar`
* Deploy `fancup-badge.clar`
* Add contract addresses to frontend
* Add contracts to Talent Protocol project
* Verify website
* Create first demo matches
* Enable user interactions

### Phase 3 — Better UX

* Match list page
* Leaderboard page
* User profile page
* Team leaderboard
* Transaction history
* Badge gallery
* Better error handling

### Phase 4 — Community Growth

* Daily prediction campaigns
* Community fan battles
* Streak events
* Supporter badge campaigns
* Stacks community demos
* Builder updates

### Phase 5 — Automation / Keeper

* Scheduled match creation
* Match closing
* Result finalization helpers
* Admin dashboard
* Safer keeper role design

---

## Current Status

```txt
Contracts: Compiling with Clarinet
Frontend: Building successfully with Next.js
Wallet: Stacks Connect integrated
Network: Mainnet-ready
Deployment: In progress
```

---

## Commands

### Contract Check

```bash
clarinet check
```

### Install Dependencies

```bash
npm install
```

### Run Dev Server

```bash
npm run dev
```

### Production Build

```bash
npm run build
```

### Git Push

```bash
git add .
git commit -m "update FanCup Stacks 2026"
git push
```

---

## Links

Website:

```txt
Coming soon
```

GitHub:

```txt
https://github.com/amandaaaaaaew23/fancup-stacks-2026
```

Mainnet Contracts:

```txt
Coming soon
```

Talent Protocol Project:

```txt
Coming soon
```

---

## License

MIT

---

## Disclaimer

FanCup Stacks 2026 is an experimental onchain fan prediction and reputation application built on Stacks.

It is not a betting platform, gambling platform, financial product, or investment product.

The project is for educational, community, and ecosystem-building purposes.

Dev update 10 Jum 12 Jun 2026 16:28:57 WIB
Dev update 11 Jum 12 Jun 2026 16:46:43 WIB
Dev update 12 Jum 12 Jun 2026 17:03:26 WIB
Dev update 6 Jum 12 Jun 2026 19:32:45 WIB
Dev update 12 Jum 12 Jun 2026 21:00:25 WIB
Dev update 18 Jum 12 Jun 2026 22:25:46 WIB
Dev update 25 Sab 13 Jun 2026 00:06:56 WIB
Dev update 58 Sab 13 Jun 2026 07:47:34 WIB
Dev update 67 Sab 13 Jun 2026 10:00:21 WIB
Dev update 68 Sab 13 Jun 2026 10:16:13 WIB
Dev update 5 Min 14 Jun 2026 05:14:09 WIB
Dev update 20 Min 14 Jun 2026 08:49:43 WIB
Dev update 32 Min 14 Jun 2026 11:40:40 WIB
Dev update 22 Sen 15 Jun 2026 01:44:09 WIB
Dev update 29 Sen 15 Jun 2026 03:18:03 WIB
Dev update 42 Sen 15 Jun 2026 06:25:26 WIB
Dev update 45 Sen 15 Jun 2026 07:08:50 WIB
Dev update 50 Sen 15 Jun 2026 08:23:34 WIB
Dev update 53 Sen 15 Jun 2026 09:10:26 WIB
Dev update 61 Sen 15 Jun 2026 11:06:46 WIB
Dev update 63 Sen 15 Jun 2026 11:36:43 WIB
Dev update 64 Sen 15 Jun 2026 11:53:20 WIB
Dev update 67 Sen 15 Jun 2026 12:39:07 WIB
Dev update 69 Sen 15 Jun 2026 13:07:50 WIB
Dev update 5 Sen 15 Jun 2026 16:00:40 WIB
Dev update 8 Sen 15 Jun 2026 16:39:54 WIB
Dev update 11 Sel 16 Jun 2026 18:20:43 WIB
Dev update 12 Sel 16 Jun 2026 18:34:31 WIB
Dev update 1 Rab 17 Jun 2026 08:43:48 WIB
Dev update 6 Rab 17 Jun 2026 09:54:05 WIB
Dev update 15 Rab 17 Jun 2026 12:01:04 WIB
Dev update 22 Rab 17 Jun 2026 13:43:41 WIB
Dev update 25 Rab 17 Jun 2026 14:27:56 WIB
Dev update 27 Rab 17 Jun 2026 15:00:25 WIB
Dev update 40 Rab 17 Jun 2026 18:10:38 WIB
Dev update 2 Kam 18 Jun 2026 23:11:07 WIB
Dev update 10 Jum 19 Jun 2026 01:00:14 WIB
Dev update 13 Jum 19 Jun 2026 01:39:10 WIB
Dev update 25 Jum 19 Jun 2026 04:39:34 WIB
Dev update 31 Jum 19 Jun 2026 06:09:14 WIB
Dev update 41 Jum 19 Jun 2026 08:34:51 WIB
Dev update 54 Jum 19 Jun 2026 11:40:29 WIB
Dev update 4 Sab 20 Jun 2026 14:45:55 WIB
Dev update 6 Sab 20 Jun 2026 15:15:17 WIB
Dev update 10 Sab 20 Jun 2026 16:16:11 WIB
Dev update 17 Sab 20 Jun 2026 18:02:04 WIB
Dev update 18 Sab 20 Jun 2026 18:17:49 WIB
Dev update 21 Sab 20 Jun 2026 19:00:50 WIB
Dev update 28 Sab 20 Jun 2026 20:41:38 WIB
Dev update 34 Sab 20 Jun 2026 22:04:22 WIB
Dev update 36 Sab 20 Jun 2026 22:33:21 WIB
Dev update 43 Min 21 Jun 2026 00:11:29 WIB
Dev update 47 Min 21 Jun 2026 01:07:24 WIB
Dev update 49 Min 21 Jun 2026 01:34:16 WIB
Dev update 56 Min 21 Jun 2026 03:14:41 WIB
Dev update 63 Min 21 Jun 2026 04:53:35 WIB
Dev update 71 Min 21 Jun 2026 06:47:18 WIB
Dev update 73 Min 21 Jun 2026 07:15:59 WIB
Dev update 92 Min 21 Jun 2026 11:50:34 WIB
Dev update 3 Min 21 Jun 2026 13:31:33 WIB
Dev update 4 Min 21 Jun 2026 13:47:20 WIB
Dev update 6 Min 21 Jun 2026 14:14:56 WIB
Dev update 103 Min 21 Jun 2026 14:22:28 WIB
Dev update 8 Min 21 Jun 2026 14:46:44 WIB
Dev update 10 Min 21 Jun 2026 15:17:06 WIB
Dev update 107 Min 21 Jun 2026 15:19:04 WIB
Dev update 15 Min 21 Jun 2026 16:26:27 WIB
Dev update 123 Min 21 Jun 2026 19:09:00 WIB
Dev update 133 Min 21 Jun 2026 21:24:32 WIB
Dev update 139 Min 21 Jun 2026 22:50:44 WIB
Dev update 141 Min 21 Jun 2026 23:21:31 WIB
Dev update 153 Sen 22 Jun 2026 02:11:34 WIB
Dev update 169 Sen 22 Jun 2026 05:58:58 WIB
Dev update 179 Sen 22 Jun 2026 08:26:49 WIB
Dev update 193 Sen 22 Jun 2026 11:43:52 WIB
Dev update 195 Sen 22 Jun 2026 12:15:00 WIB
Dev update 197 Sen 22 Jun 2026 12:42:03 WIB
Dev update 198 Sen 22 Jun 2026 12:56:57 WIB
Dev update 202 Sen 22 Jun 2026 13:56:41 WIB
Dev update 206 Sen 22 Jun 2026 14:51:13 WIB
Dev update 207 Sen 22 Jun 2026 15:07:46 WIB
Dev update 221 Sen 22 Jun 2026 18:18:40 WIB
Dev update 224 Sen 22 Jun 2026 19:06:06 WIB
Dev update 225 Sen 22 Jun 2026 19:20:10 WIB
Dev update 228 Sen 22 Jun 2026 20:02:16 WIB
Dev update 242 Sen 22 Jun 2026 23:28:53 WIB
Dev update 252 Sel 23 Jun 2026 01:49:05 WIB
Dev update 255 Sel 23 Jun 2026 02:35:01 WIB
Dev update 263 Sel 23 Jun 2026 04:31:22 WIB
Dev update 272 Sel 23 Jun 2026 06:42:13 WIB
Dev update 286 Sel 23 Jun 2026 10:02:09 WIB
Dev update 287 Sel 23 Jun 2026 10:13:48 WIB
Dev update 298 Sel 23 Jun 2026 12:53:46 WIB
Dev update 300 Sel 23 Jun 2026 13:21:21 WIB
Dev update 1 Sel 23 Jun 2026 19:18:31 WIB
Dev update 6 Sel 23 Jun 2026 20:29:11 WIB
Dev update 8 Sel 23 Jun 2026 20:57:31 WIB
Dev update 11 Sel 23 Jun 2026 21:44:06 WIB
Dev update 23 Rab 24 Jun 2026 00:28:46 WIB
Dev update 1 Kam 25 Jun 2026 13:18:02 WIB
Dev update 2 Kam 25 Jun 2026 13:32:05 WIB
Dev update 3 Kam 25 Jun 2026 13:45:06 WIB
Dev update 7 Kam 25 Jun 2026 14:38:06 WIB
Dev update 10 Kam 25 Jun 2026 15:20:35 WIB
Dev update 18 Kam 25 Jun 2026 17:13:24 WIB
Dev update 8 Sab 27 Jun 2026 02:20:52 WIB
Dev update 16 Sab 27 Jun 2026 04:09:24 WIB
Dev update 20 Sab 27 Jun 2026 05:07:39 WIB
Dev update 23 Sab 27 Jun 2026 05:49:19 WIB
Dev update 44 Sab 27 Jun 2026 11:01:55 WIB
