// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "..src/RWACarCCIPWrapper.sol";

contract RWACarCCIPReceiverTest is Test {
    RWACarCCIPWrapper rWACarCCIPWrapper;

    function setUp() public {
        // Deploy a fresh instance for each test
        rWACarCCIPWrapper = new RWACarCCIPWrapper();
    }

    function testSetAllowedSourceChain() public {
        uint256 chainId = 1; // Replace with actual chain ID
        rWACarCCIPWrapper.setAllowedSourceChain(chainId, true);
        bool isAllowed = rWACarCCIPWrapper.isSourceChainAllowed(chainId);
        assertTrue(isAllowed, "Chain should be allowed.");
    }

    function testLockAndSend() public {
        address recipient = address(0x123); // Replace with desired recipient
        uint256 amount = 1000; // Example amount

        rWACarCCIPWrapper.lockAndSend(recipient, amount);

        // TODO: Add assertions depending on lockAndSend’s state changes
        // For example:
        // assertTrue(rWACarCCIPWrapper.isTokenLocked(address(rWACarCCIPWrapper)));
    }

    function testEmergencyUnlock() public {
        // Call emergency unlock
        rWACarCCIPWrapper.emergencyUnlock();

        // TODO: Add assertions to verify unlock state
        // Example: assertFalse(rWACarCCIPWrapper.isTokenLocked(address(rWACarCCIPWrapper)));
    }

    function testIsTokenLocked() public {
        address tokenAddress = address(rWACarCCIPWrapper);
        bool locked = rWACarCCIPWrapper.isTokenLocked(tokenAddress);
        assertFalse(locked, "Token should not be locked initially.");

        rWACarCCIPWrapper.lockAndSend(address(0x123), 1000);
        locked = rWACarCCIPWrapper.isTokenLocked(tokenAddress);
        assertTrue(locked, "Token should be locked after locking and sending.");
    }
}