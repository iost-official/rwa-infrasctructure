# Yield Token Protocol

A protocol for managing yield-bearing tokens with integrated merchant functionality.

## Overview

This protocol implements a yield-bearing token system with the following key features:
- ERC20-compatible yield tokens
- Merchant functionality for token trading
- Role-based access control
- Secure withdrawal mechanism with signatures

## Repository Structure

```
src/
├── config/
│   ├── constants.sol     # Protocol-wide constants and configurations
│   ├── errors.sol        # Custom error definitions
│   └── roles.sol         # Role definitions for access control
├── core/
│   ├── manager/
│   │   └── MMFManager.sol    # Main Money Market Fund management contract
│   └── token/
│       └── FundToken.sol     # Implementation of the yield-bearing token
├── interfaces/
│   ├── IAuthority.sol        # Interface for role-based access control
│   ├── IMintableBurnable.sol # Interface for token minting/burning
│   └── ITokenPriceOracle.sol # Interface for price feed integration
└── utils/                    # Utility contracts and libraries
```

### Key Components

- **MMFManager.sol**: Core contract managing the Money Market Fund operations including:
  - Token subscription (deposits)
  - Token redemption (withdrawals)
  - Fee management
  - Price oracle integration

- **FundToken.sol**: ERC20-compatible token representing shares in the fund
  - Implements minting/burning functionality
  - Tracks user balances and total supply

- **Interfaces**: Define the contract interactions
  - `IAuthority`: Role-based access control
  - `ITokenPriceOracle`: Price feed integration
  - `IMintableBurnable`: Token minting and burning operations

## Development

### Prerequisites

- [Foundry](https://github.com/foundry-rs/foundry)
- Solidity ^0.8.0

### Installation

1. Clone the repository:

```
git clone https://github.com/iost-official/rwa-infrastructure.git
cd rwa-infrastructure 
```

Install dependencies:

```
forge install
```

### Usage

Compile the contracts:

```
forge build
```

Test the contracts:

```
forge test
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.md) file for details.


