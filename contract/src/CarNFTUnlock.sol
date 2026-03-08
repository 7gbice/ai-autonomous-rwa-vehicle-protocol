// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {
    CCIPReceiver
} from "node_modules/@chainlink/contracts-ccip/contracts/applications/CCIPReceiver.sol";
import {
    Client
} from "node_modules/@chainlink/contracts-ccip/contracts/libraries/Client.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract CarNFTUnlock is CCIPReceiver, Ownable {
    IERC721 public carNft;

    // constructor(address _router, address _carNFT) CCIPReceiver(_router) {
    //     carNFT = IERC721(_carNFT);
    // }

    constructor(
        address _router,
        address _carNft
    ) CCIPReceiver(_router) Ownable(msg.sender) {
        carNft = IERC721(_carNft);
    }

    function _ccipReceive(
        Client.Any2EVMMessage memory message
    ) internal override {
        (uint256 tokenId, address owner) = abi.decode(
            message.data,
            (uint256, address)
        );
        carNft.transferFrom(address(this), owner, tokenId);
    }
}
