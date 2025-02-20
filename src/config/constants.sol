// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @dev Fees are 18-decimal places. For example: 20 * 10**18 = 20%
uint256 constant FEE_MULTIPLIER = 10 ** 18;
uint256 constant HUNDRED_PCT = 100 * FEE_MULTIPLIER;
