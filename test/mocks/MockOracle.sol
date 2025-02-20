// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ITokenPriceOracle} from "../../src/interfaces/ITokenPriceOracle.sol";

contract MockOracle is ITokenPriceOracle {
    int256 private _price;

    function setPrice(int256 price) external {
        _price = price;
    }

    function getRoundData(uint80) external pure returns (uint80, int256, uint256, uint256, uint80) { 
        return (0,0,0,0,0); 
    }

    function latestRoundData() external view returns (uint80, int256, uint256, uint256, uint80) {
        return (0, _price, 0, 0, 0);
    }

    function decimals() external pure returns (uint8) {
        return 8;
    }

    function description() external pure returns (string memory) { return ""; }
    function version() external pure returns (uint256) { return 1; }
} 