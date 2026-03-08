// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import "forge-std/console2.sol";
import {RWA_CarNFT} from "../src/RWA_CarNFT.sol";
import {RWACarCCIPWrapper} from "../src/RWACarCCIPWrapper.sol";

contract Deploy is Script {
    // CCIP Router addresses (testnets, all lowercase, 40 hex digits)
    address constant FUJI_ROUTER = 0x1c6CB2AB3A0F1A2b4E7cfF3a9D6a7AFF0B8d7fA6;
    address constant SEPOLIA_ROUTER =
        0x447Fd5eC2D383091C22B8549cb231a3bAD6d3fAf;
    address constant MUMBAI_ROUTER = 0x3A2Fd0cC2B6a6A3Fff9D7Cff3A9d6a7Aff0b8D7f;
    address constant ARBITRUM_SEPOLIA_ROUTER =
        0x2d1fC0AB3A0F1a2b4e7cFF3a9d6a7aFF0B8D7fA6;
    address constant OPTIMISM_SEPOLIA_ROUTER =
        0x5c6cB2AB3a0f1a2B4e7CFF3a9D6A7AfF0b8d7fA6;
    address constant BASE_SEPOLIA_ROUTER =
        0x7C6cB2AB3A0F1a2b4E7cFF3A9D6A7afF0b8D7fA6;

    function run() external {
        vm.startBroadcast();

        RWA_CarNFT carNft = new RWA_CarNFT();

        uint256 chainId = block.chainid;
        address router;

        if (chainId == 43113) router = FUJI_ROUTER;
        else if (chainId == 11155111) router = SEPOLIA_ROUTER;
        else if (chainId == 80001) router = MUMBAI_ROUTER;
        else if (chainId == 421614) router = ARBITRUM_SEPOLIA_ROUTER;
        else if (chainId == 11155420) router = OPTIMISM_SEPOLIA_ROUTER;
        else if (chainId == 84532) router = BASE_SEPOLIA_ROUTER;
        else revert("Unsupported chain");

        RWACarCCIPWrapper wrapper = new RWACarCCIPWrapper(
            router,
            payable(address(carNft))
        );

        vm.stopBroadcast();

        console2.log("RWA_CarNFT deployed at:", address(carNft));
        console2.log("RWACarCCIPWrapper deployed at:", address(wrapper));
        console2.log("Router used:", router);
        console2.log("Chain ID:", chainId);
    }
}
