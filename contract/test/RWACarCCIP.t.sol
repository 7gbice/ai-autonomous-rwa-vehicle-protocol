// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/RWA_CarNFT.sol";
import "../src/RWACarCCIPWrapper.sol";

contract RWACarCCIPTest is Test {
    RWA_CarNFT carNft;
    RWACarCCIPWrapper wrapper;
    address owner = address(0x123);
    address receiver = address(0x456);
    uint64 destChainSelector = 11155111; // Sepolia chain selector

    function setUp() public {
        // Deploy NFT + wrapper
        carNft = new RWA_CarNFT();
        wrapper = new RWACarCCIPWrapper(
            address(0x999),
            payable(address(carNft))
        );

        // Mint NFT to owner
        vm.startPrank(owner);
        carNft.mintCarNFT(
            "VIN123",
            "Tesla",
            "Model S",
            2024,
            1000,
            "Black",
            "White",
            "AWD",
            "Electric",
            "Auto",
            "SaleDoc",
            true,
            80000,
            "ipfs://tokenuri"
        );
        vm.stopPrank();
    }

    function testLockNFT() public {
        vm.startPrank(owner);

        // Owner approves wrapper to transfer NFT
        carNft.approve(address(wrapper), 0);

        // Lock and send
        bytes32 messageId = wrapper.lockAndSend(destChainSelector, 0, receiver);

        assertTrue(wrapper.isLocked(0));
        vm.stopPrank();
    }

    function testUnlockNFT() public {
        vm.startPrank(owner);

        // Approve and lock first
        carNft.approve(address(wrapper), 0);
        wrapper.lockAndSend(destChainSelector, 0, receiver);

        // Simulate CCIP unlock message
        wrapper.setAllowedSourceChain(destChainSelector, true);
        bytes memory data = abi.encode(uint256(0), owner);

        // Call _ccipReceive manually
        Client.Any2EVMMessage memory msgData = Client.Any2EVMMessage({
            messageId: bytes32("fake"),
            sourceChainSelector: destChainSelector,
            sender: abi.encode(receiver),
            data: data,
            destTokenAmounts: new Client.EVMTokenAmount[](0)
        });

        wrapper.ccipReceive(msgData);

        assertFalse(wrapper.isLocked(0));
        assertEq(carNft.ownerOf(0), owner);
        vm.stopPrank();
    }
}
