// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/* ------------------------ *
 *      Shared Errors       *
 * -----------------------  */

error NoAccess();
error NoUnderlying();
error NotPermissioned();

/* ------------------------ *
 *      Token Errors         *
 * -----------------------  */

error BadFee();
error BadAddress();
error BadAmount();
error BadPrice();
error BadOracleDecimals();
error FeesPending();
error InvalidSignature();

/* ------------------------ *
 *    Aggregators Errors    *
 * -----------------------  */
error RoundDataReported();
error StaleAnswer();
error Overflow();
error InsufficientGas();

/* ------------------------ *
 *    Other Errors     *
 * -----------------------  */
error NotSupported();
error NonceUsed();
error CallFailed();
error InvalidGasFee();
error InvalidArrayLength();
error InvalidString();
