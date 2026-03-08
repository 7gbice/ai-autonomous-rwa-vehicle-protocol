// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {CCIPSender} from "./CCIPSender.sol";
import {
    CCIPReceiver
} from "node_modules/@chainlink/contracts-ccip/contracts/applications/CCIPReceiver.sol";
import {
    Client
} from "node_modules/@chainlink/contracts-ccip/contracts/libraries/Client.sol";
import {
    IRouterClient
} from "node_modules/@chainlink/contracts-ccip/contracts/interfaces/IRouterClient.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {RWA_CarNFT} from "./RWA_CarNFT.sol";

/**
 * @title RWACarCCIPWrapper
 * @dev Wraps the RWA_CarNFT contract to allow locking NFTs and sending cross-chain unlock instructions via Chainlink CCIP.
 */
contract RWACarCCIPWrapper is CCIPSender, CCIPReceiver, Ownable {
    RWA_CarNFT public immutable RWACAR;

    // Mapping to track locked NFTs
    mapping(uint256 => bool) public isLocked;
    
    // Mapping to track which chains are allowed to send unlock messages
    mapping(uint64 => bool) public allowedSourceChains;

    // Mapping to track which chains are allowed to send unlock messages
    mapping(uint64 => bool) public allowedSourceChains;

    /// @notice Emitted when an NFT is locked for cross-chain transfer.
    event CarNFTLocked(
        uint256 indexed tokenId,
        uint64 indexed destinationChainSelector,
        address receiver,
        bytes32 messageId
    );

    /// @notice Emitted when a cross-chain unlock request is received.
    event CrossChainUnlockRequested(
        uint256 indexed tokenId,
        address indexed owner,
        bytes32 messageId
    );

    /// @notice Emitted when an NFT is unlocked.
    event CarNFTUnlocked(uint256 indexed tokenId, address indexed to);

    constructor(
        address _router,
        address payable _rwaCar
    ) CCIPSender(_router) CCIPReceiver(_router) Ownable(msg.sender) {
        RWACAR = RWA_CarNFT(_rwaCar);
    }

    /**
     * @notice Locks the NFT and initiates a CCIP message to the destination chain.
     * @param destinationChainSelector The selector of the destination chain.
     * @param tokenId The tokenId of the NFT to lock.
     * @param receiver The address of the receiver contract on the destination chain.
     * @return messageId The unique ID of the CCIP message.
     */
    function lockAndSend(
        uint64 destinationChainSelector,
        uint256 tokenId,
        address receiver
    ) external returns (bytes32 messageId) {
        require(RWACAR.ownerOf(tokenId) == msg.sender, "Not NFT owner");
        require(!isLocked[tokenId], "Already locked");

        // Transfer NFT to wrapper and lock
        RWACAR.transferFrom(msg.sender, address(this), tokenId);
        isLocked[tokenId] = true;

        // Prepare cross-chain message
        bytes memory data = abi.encode(tokenId, msg.sender);
        messageId = _ccipSend(destinationChainSelector, receiver, data);

        emit CarNFTLocked(
            tokenId,
            destinationChainSelector,
            receiver,
            messageId
        );
    }

    /**
     * @notice Allows owner to set which source chains can send unlock messages.
     * @param sourceChainSelector The chain selector to allow/disallow.
     * @param allowed Whether to allow messages from this chain.
     */
    function setAllowedSourceChain(
        uint64 sourceChainSelector,
        bool allowed
    ) external onlyOwner {
        allowedSourceChains[sourceChainSelector] = allowed;
    }

    /**
     * @notice Handles CCIP incoming messages (unlock requests from other chains).
     * @dev This function is called automatically by the CCIP Router.
     */
    function _ccipReceive(
        Client.Any2EVMMessage memory message
    ) internal override {
        // Verify the message came from an allowed source chain
        require(
            allowedSourceChains[message.sourceChainSelector],
            "Unauthorized source chain"
        );

        // Decode the message data
        (uint256 tokenId, address owner) = abi.decode(
            message.data,
            (uint256, address)
        );

        // Unlock the NFT
        _unlockInternal(tokenId, owner);
<<<<<<< HEAD
        
=======

>>>>>>> 92c6633 (update)
        emit CrossChainUnlockRequested(tokenId, owner, message.messageId);
    }

    /**
     * @notice Internal function to unlock an NFT and transfer it to the owner.
     * @param tokenId The tokenId of the NFT to unlock.
     * @param to The address to send the unlocked NFT to.
     */
    function _unlockInternal(uint256 tokenId, address to) internal {
        require(isLocked[tokenId], "NFT not locked");
        require(to != address(0), "Invalid recipient");
<<<<<<< HEAD
        
=======

>>>>>>> 92c6633 (update)
        isLocked[tokenId] = false;
        RWACAR.transferFrom(address(this), to, tokenId);

        emit CarNFTUnlocked(tokenId, to);
    }

    /**
     * @notice Allows owner to manually unlock an NFT (emergency function).
     * @param tokenId The tokenId of the NFT to unlock.
     * @param to The address to send the unlocked NFT to.
     */
    function emergencyUnlock(uint256 tokenId, address to) external onlyOwner {
        _unlockInternal(tokenId, to);
<<<<<<< HEAD
=======
    }

    function unlock(uint256 tokenId, address to) external onlyOwner {
        _unlockInternal(tokenId, to);
    }

    function sell(
        uint256 tokenId,
        address buyer,
        uint256 priceUsd
    ) external onlyOwner {
        require(isLocked[tokenId], "Token must be locked before sale");

        // Unlock and transfer to buyer
        isLocked[tokenId] = false;
        RWACAR.transferFrom(address(this), buyer, tokenId);

        emit CarNFTUnlocked(tokenId, buyer);
        // You could also emit a CarNFTSold event here if you want
>>>>>>> 92c6633 (update)
    }

    /**
     * @notice Returns whether a token is locked.
     * @param tokenId The tokenId to query.
     * @return True if locked, false otherwise.
     */
    function isTokenLocked(uint256 tokenId) external view returns (bool) {
        return isLocked[tokenId];
    }

<<<<<<< HEAD
    receive() external payable {}
}
=======
    receive() external payable override {}
}
>>>>>>> 92c6633 (update)
