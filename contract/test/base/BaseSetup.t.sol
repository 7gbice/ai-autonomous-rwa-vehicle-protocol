// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

import {RWA_CarNFT} from "../../src/RWA_CarNFT.sol";
import {RWACarCCIPWrapper} from "../../src/RWACarCCIPWrapper.sol";
import {MockCCIPRouter} from "../mocks/MockCCIPRouter.sol";

contract BaseSetup is Test {
    RWA_CarNFT public carNFT;
    RWACarCCIPWrapper public wrapper;
    MockCCIPRouter public router;

    address public owner = address(1);
    address public buyer = address(2);

    uint256 public tokenId = 0;

    uint64 DEST_CHAIN_SELECTOR = 2183018362218727504;

    function setUp() public virtual {
        vm.startPrank(owner);

        router = new MockCCIPRouter();

        carNFT = new RWA_CarNFT();

        wrapper = new RWACarCCIPWrapper(
            address(router),
            payable(address(carNFT))
        );

        vm.stopPrank();
    }
}
