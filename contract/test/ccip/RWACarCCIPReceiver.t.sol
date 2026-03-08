// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../RWACarCCIPWrapper.sol";
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";

contract RWACarCCIPReceiverTest {
    RWACarCCIPWrapper rWACarCCIPWrapper;

    // Move to the setup function to initialize the contract
    function beforeAll() public {
        rWACarCCIPWrapper = RWACarCCIPWrapper(DeployedAddresses.RWACarCCIPWrapper());
    }

    // Test for setAllowedSourceChain
    function testSetAllowedSourceChain() public {
        uint256 chainId = 1;  // Replace with actual chain ID
        rWACarCCIPWrapper.setAllowedSourceChain(chainId, true);
        bool isAllowed = rWACarCCIPWrapper.isSourceChainAllowed(chainId);
        Assert.isTrue(isAllowed, "Chain should be allowed.");
    }

    // Test for lockAndSend
    function testLockAndSend() public {
        address recipient = address(0x123);  // Replace with desired recipient
        uint256 amount = 1000;  // Example amount

        rWACarCCIPWrapper.lockAndSend(recipient, amount);

        // Insert appropriate assertion logic and states to verify
    }

    // Test for emergencyUnlock
    function testEmergencyUnlock() public {
        // Assuming contract has a modifier or a condition for it
        rWACarCCIPWrapper.emergencyUnlock();

        // Check state to assure that unlock has been successful
    }

    // Test for isTokenLocked
    function testIsTokenLocked() public {
        address tokenAddress = address(rWACarCCIPWrapper);  // Example token address
        bool locked = rWACarCCIPWrapper.isTokenLocked(tokenAddress);
        // Verify if token is locked at the beginning
        Assert.isFalse(locked, "Token should not be locked initially.");

        // Now lock the token and verify
        rWACarCCIPWrapper.lockAndSend(address(0x123), 1000);
        locked = rWACarCCIPWrapper.isTokenLocked(tokenAddress);
        Assert.isTrue(locked, "Token should be locked after locking and sending.");
    }
}