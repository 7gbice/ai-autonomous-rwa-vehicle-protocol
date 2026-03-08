// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {CCIPSender} from "./CCIPSender.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title CarNFTLock
 * @notice Locks an NFT and sends cross-chain metadata using Chainlink CCIP.
 */
contract CarNFTLock is CCIPSender, Ownable {
    IERC721 public carNft;

    // constructor(address _carNFT, address _router) CCIPSender(_router) {
    //     carNFT = IERC721(_carNFT);
    // }
    constructor(
        address _carNft,
        address _router
    ) CCIPSender(_router) Ownable(msg.sender) {
        carNft = IERC721(_carNft);
    }

    /**
     * @notice Locks the NFT and sends a CCIP message to the destination chain.
     * @param tokenId The ID of the NFT to lock.
     * @param destinationChainSelector The CCIP chain selector for the destination.
     * @param receiver The receiver address on the destination chain.
     */
    function lockAndSend(
        uint256 tokenId,
        uint64 destinationChainSelector,
        address receiver
    ) external {
        require(carNft.ownerOf(tokenId) == msg.sender, "Not NFT owner");

        // Lock: transfer NFT to this contract
        carNft.transferFrom(msg.sender, address(this), tokenId);

        // Encode tokenId and sender into bytes
        bytes memory message = abi.encode(tokenId, msg.sender);

        // Use correct public function
        _ccipSend(destinationChainSelector, receiver, message);
    }
}
