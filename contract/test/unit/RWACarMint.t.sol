// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../base/BaseSetup.t.sol";

contract RWACarMintTest is BaseSetup {
    function testMintCar() public {
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

        assertEq(carNFT.ownerOf(tokenId), owner);

        vm.stopPrank();
    }
}
