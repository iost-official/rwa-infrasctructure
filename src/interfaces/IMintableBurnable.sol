// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IMintableBurnable {
    /**
     * @dev mint money market coin to an address. Can only be called by authorized minter
     * @param to    where to mint token to
     * @param amount       amount to mint
     *
     */
    function mint(address to, uint256 amount) external;

    /**
     * @dev burn money market coin from an address. Can only be called by holder
     * @param amount       amount to burn
     *
     */
    function burn(uint256 amount) external;

    /**
     * @dev burn money market coin from a specified address. Can only be called by authorized burner
     * @param from        address to burn tokens from
     * @param amount      amount to burn
     */
    function burnFrom(address from, uint256 amount) external;
}
