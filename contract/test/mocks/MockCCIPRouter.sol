// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MockCCIPRouter {
    event MessageSent(
        uint64 destinationChainSelector,
        address receiver,
        bytes data
    );

    function ccipSend(
        uint64 destinationChainSelector,
        bytes calldata message
    ) external payable returns (bytes32) {
        emit MessageSent(destinationChainSelector, msg.sender, message);

        return keccak256(message);
    }
}
