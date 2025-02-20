// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IMintableBurnable} from "../../interfaces/IMintableBurnable.sol";
import {IAuthority} from "../../interfaces/IAuthority.sol";

import "../../config/errors.sol";
import {Role} from "../../config/roles.sol";

/**
 * @title FundToken
 * @dev A basic ERC20 token with minting and burning capabilities
 */
contract FundToken is ERC20, IMintableBurnable {
    IAuthority public immutable authority;

    /// @notice The address that has permission to mint tokens
    address public minter;
    /// @notice The address that has permission to burn tokens
    address public burner;

    /**
     * @dev Constructor that sets the token name, symbol and minter
     * @param name_ The name of the token
     * @param symbol_ The symbol of the token
     */
    constructor(
        string memory name_,
        string memory symbol_,
        address authority_
    ) ERC20(name_, symbol_) {
        authority = IAuthority(authority_);
        minter = address(0);
        burner = address(0);
    }

    /**
     * @dev set the minter and burner addresses
     * @param minter_ The address that will have minting permissions
     * @param burner_ The address that will have burning permissions
     */
     // TODO: add permission check
    function setMinterAndBurner(address minter_, address burner_) external {
        if (!authority.doesUserHaveRole(msg.sender, Role.System_Admin)) revert NotPermissioned();
        minter = minter_;
        burner = burner_;
    }

    /**
     * @dev Modifier to check if caller is the minter
     */
    modifier onlyMinter() {
        if (msg.sender != minter) revert("FundToken: caller is not the minter");
        _;
    }

    /**
     * @dev Modifier to check if caller is the burner
     */
    modifier onlyBurner() {
        if (msg.sender != burner) revert("FundToken: caller is not the burner");
        _;
    }

    /**
     * @dev Creates `amount` tokens and assigns them to `to`
     * @param to The address to mint tokens to
     * @param amount The amount of tokens to mint
     */
    function mint(address to, uint256 amount) external onlyMinter {
        _mint(to, amount);
    }

    /**
     * @dev Burns `amount` tokens from the account
     * @param amount The amount of tokens to burn
     */
    function burn(uint256 amount) external onlyBurner {
        _burn(msg.sender, amount);
    }

    /**
     * @dev Burns `amount` tokens from `from` address
     * @param from The address to burn tokens from
     * @param amount The amount of tokens to burn
     */
    function burnFrom(address from, uint256 amount) external onlyBurner {
        _burn(from, amount);
    }
}
