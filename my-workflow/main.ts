import {
  CronCapability,
  HTTPClient,
  EVMClient,
  handler,
  consensusMedianAggregation,
  Runner,
  type NodeRuntime,
  type Runtime,
  getNetwork,
  LAST_FINALIZED_BLOCK_NUMBER,
  encodeCallMsg,
  bytesToHex,
} from "@chainlink/cre-sdk"
import { encodeFunctionData, decodeFunctionResult, zeroAddress } from "viem"
import { Storage } from "../contracts/abi"

export type Config = {
  chainId: number;           // source chain ID
  contractAddress: string;   // wrapper contract address
  apiUrl: string;            // off-chain API
  destChainId: number;       // destination chain ID
  destContractAddress: string;
  selector: string;
};

export const initWorkflow = (config: Config) => {
  const evmEvent = new EvmEvent();

  return [
    handler(
      evmEvent.trigger({
        chainId: config.chainId,
        address: config.contractAddress,
        event: "CarNFTLocked(address indexed owner,uint256 indexed tokenId)",
      }),
      async (runtime, event) => {
        runtime.log("Workflow triggered by CarNFTLocked event.");

        // Off-chain API check
        const http = new Http(runtime);
        const response = await http.get(config.apiUrl);
        runtime.log(`API response: ${JSON.stringify(response)}`);

        if (!response.data.registered) {
          runtime.log("Vehicle not registered. Aborting lock.");
          return "Aborted";
        }

        // Contract call
        const evm = new Evm(runtime);
        const tx = await evm.call({
          chainId: config.destChainId,
          address: config.destContractAddress,
          function: "lockAndSend(uint64,uint256,address)",
          args: [config.selector, event.tokenId, event.owner],
        });

        runtime.log(`Transaction hash: ${tx.hash}`);
        return tx.hash;
      }
    ),
  ];
};

export async function main() {
  const runner = await Runner.newRunner<Config>();
  await runner.run(initWorkflow);
}
