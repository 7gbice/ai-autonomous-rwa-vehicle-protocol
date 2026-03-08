// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../base/BaseSetup.t.sol";

contract RWACarCCIPMessageTest is BaseSetup {
    function testCCIPMessage() public {
        vm.startPrank(owner);

        carNFT.mintCarNFT(
            "VIN123",
            "Tesla",
            "Model S",
            2023,
            1000,
            "Black",
            "White",
            "AWD",
            "Electric",
            "Auto",
            "BillOfSale",
            true,
            80000,
            "ipfs://metadata"
        );

        carNFT.approve(address(wrapper), tokenId);

        wrapper.lockAndSend(DEST_CHAIN_SELECTOR, tokenId, address(999));

        vm.stopPrank();

        // Simulate receiving the CCIP message and unlocking the NFT on the destination chain
        wrapper.unlock(tokenId, owner);

        assertEq(carNFT.ownerOf(tokenId), owner);
    }
}
