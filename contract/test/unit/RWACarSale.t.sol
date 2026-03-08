// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../../src/RWA_CarNFT.sol";

contract RWACarSaleTest is Test {
    RWA_CarNFT carNft;
    address seller = address(0xAAA);
    address buyer = address(0xBBB);

    function setUp() public {
        carNft = new RWA_CarNFT();

        // Grant MINTER_ROLE to seller so they can mint
        carNft.grantRole(carNft.MINTER_ROLE(), seller);

        // Mint car NFT to seller
        vm.startPrank(seller);
        carNft.mintCarNFT(
            "VIN123",
            "Toyota",
            "Corolla",
            2022,
            5000,
            "Blue",
            "Gray",
            "FWD",
            "Gasoline",
            "Automatic",
            "SaleDoc",
            true,
            20000e8, // initial purchase amount in USD (8 decimals)
            "ipfs://tokenuri"
        );
        vm.stopPrank();
    }

    function testSellCar() public {
        // Seller lists car for sale
        vm.startPrank(seller);
        carNft.listCarForSale(0, 15000e8); // price in USD (8 decimals)
        vm.stopPrank();

        // Give buyer ETH
        vm.deal(buyer, 10 ether);

        // Buyer purchases car
        vm.prank(buyer);
        carNft.buyCar{value: 2 ether}(0); // send enough ETH

        // Assert buyer is new owner
        assertEq(carNft.ownerOf(0), buyer);
    }
}
