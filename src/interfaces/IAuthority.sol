// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import "../config/roles.sol";

/// @notice A generic interface for a contract which provides authorization data to an Auth instance.
/// @author Modified from Dappsys (https://github.com/dapphub/ds-auth/blob/master/src/auth.sol)
interface IAuthority {
    function canCall(address user, address target, bytes4 functionSig) external view returns (bool);

    function doesUserHaveRole(address user, Role role) external view returns (bool);

    function getUserRoles(address user) external view returns (bytes32);
}
