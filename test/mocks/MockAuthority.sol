// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAuthority} from "../../src/interfaces/IAuthority.sol";
import {Role} from "../../src/config/roles.sol";

contract MockAuthority is IAuthority {
    mapping(address => mapping(Role => bool)) private _roles;

    function grantRole(Role role, address user) external {
        _roles[user][role] = true;
    }

    function revokeRole(Role role, address user) external {
        _roles[user][role] = false;
    }

    function canCall(address user, address, bytes4) external view returns (bool) {
        return _roles[user][Role.Investor_Whitelisted];
    }

    function doesUserHaveRole(address user, Role role) external view returns (bool) {
        return _roles[user][role];
    }

    function getUserRoles(address) external pure returns (bytes32) {
        return bytes32(0);
    }
}