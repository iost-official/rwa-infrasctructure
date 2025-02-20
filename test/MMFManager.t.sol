// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "../lib/forge-std/src/Test.sol";
import {MMFManager} from "../src/core/manager/MMFManager.sol";
import {FundToken} from "../src/core/token/FundToken.sol";
import {MockERC20} from "./mocks/MockERC20.sol";
import {MockOracle} from "./mocks/MockOracle.sol";
import {MockAuthority} from "./mocks/MockAuthority.sol";
import {Role} from "../src/config/roles.sol";

contract MMFManagerTest is Test {
    MMFManager public manager;
    MockERC20 public stable;
    FundToken public yToken;
    MockOracle public oracle;
    MockAuthority public authority;
    
    address public owner = address(1);
    address public feeRecipient = address(2);
    address public user = address(3);
    
    uint256 constant DEFAULT_BUY_FEE = 0.01e18; // 1%
    uint256 constant DEFAULT_SELL_FEE = 0.01e18; // 1%

    function setUp() public {
        // Deploy mock contracts
        stable = new MockERC20("Stable", "USDC", 6);
        oracle = new MockOracle();
        authority = new MockAuthority();


        // Deploy FundToken with manager as minter and burner
        yToken = new FundToken(
            "Yield Token",
            "YT",
            address(authority)
        );

        // Create new manager with correct yToken address
        manager = new MMFManager(
            address(yToken),
            address(oracle),
            address(authority),
            feeRecipient,
            address(stable),
            DEFAULT_BUY_FEE,
            DEFAULT_SELL_FEE
        );


        // Setup initial states
        vm.startPrank(owner);
        authority.grantRole(Role.System_Admin, owner);
        yToken.setMinterAndBurner(address(manager), address(manager));
        vm.stopPrank();


        // Whitelist user and recipient
        authority.grantRole(Role.Investor_Whitelisted, user);

        // Approve manager to spend tokens
        vm.startPrank(user);
        stable.approve(address(manager), type(uint256).max);
        yToken.approve(address(manager), type(uint256).max);
        vm.stopPrank();
    }

    function testConstructor() public {
        assertEq(address(manager.ytoken()), address(yToken));
        assertEq(address(manager.oracle()), address(oracle));
        assertEq(address(manager.authority()), address(authority));
        assertEq(address(manager.feeRecipient()), feeRecipient);
    }

    function testInitialize() public {
        assertEq(address(manager.stable()), address(stable));
        assertEq(manager.buyFee(), DEFAULT_BUY_FEE);
        assertEq(manager.sellFee(), DEFAULT_SELL_FEE);
    }

    function testSetFees() public {
        uint256 newBuyFee = 0.02e18;
        uint256 newSellFee = 0.03e18;

        vm.startPrank(owner);
        manager.setFees(newBuyFee, newSellFee);
        vm.stopPrank();

        assertEq(manager.buyFee(), newBuyFee);
        assertEq(manager.sellFee(), newSellFee);
    }

    function testSetFeesUnauthorized() public {
        vm.startPrank(user);
        vm.expectRevert();
        manager.setFees(0.02e18, 0.03e18);
        vm.stopPrank();
    }

    function testSubscribeFor() public {
        uint256 stableBalance = 1000e6;
        // Mint stable coins to user
        stable.mint(user, stableBalance);
        // Set oracle price to $1
        oracle.setPrice(1e8);

        uint256 subscribeAmount = 100e6; // 100 USDC
        
        vm.startPrank(user);
        uint256 tokensReceived = manager.subscribeFor(
            user,
            subscribeAmount
        );
        vm.stopPrank();

        // Expected tokens received should be 99.99 (100 - 0.01% fee)
        assertEq(tokensReceived, 99.99e18);
        assertEq(yToken.balanceOf(user), 99.99e18);
        assertEq(stable.balanceOf(user), 900e6);
    }

    function testSubscribeForUnwhitelisted() public {
        // Remove whitelist from user
        authority.revokeRole(Role.Investor_Whitelisted, user);

        vm.startPrank(user);
        vm.expectRevert();
        manager.subscribeFor(
            user,
            100e6
        );
        vm.stopPrank();
    }

    function testRedeemTo() public {
        // Set oracle price to $1
        oracle.setPrice(1e8);

        uint256 redeemAmount = 100e18; // 100 tokens
        
        // Need to mint tokens to user first
        vm.startPrank(address(manager));
        yToken.mint(user, redeemAmount);
        stable.mint(address(manager), 1000000e6);
        vm.stopPrank();
        
        vm.startPrank(user);
        uint256 stableReceived = manager.redeemTo(
            user,
            redeemAmount
        );
        vm.stopPrank();

        // Expected stable received should be 99.99 (100 - 0.01% fee)
        assertEq(stableReceived, 99.99e6);
        assertEq(stable.balanceOf(user), 99.99e6);
        assertEq(yToken.balanceOf(user), 0);
    }

    function testRedeemToUnwhitelisted() public {
        // Remove whitelist from recipient
        authority.revokeRole(Role.Investor_Whitelisted, user);

        vm.startPrank(user);
        vm.expectRevert();
        manager.redeemTo(
            user,
            100e6
        );
        vm.stopPrank();
    }
}
