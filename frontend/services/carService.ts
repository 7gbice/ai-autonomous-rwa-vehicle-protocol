import { ethers } from "ethers";
import { getSigner } from "@/lib/web3";

const wrapperAddress = 0xeceb2acd4338a22c235b184a12a04e19cd015102; //"YOUR_DEPLOYED_WRAPPER_ADDRESS";

const abi = [
  "function lockAndSend(uint64,uint256,address) external returns(bytes32)"
];

export async function lockCar(
  chainSelector: number,
  tokenId: number
) {
  const signer = await getSigner();

  const contract = new ethers.Contract(wrapperAddress, abi, signer);

  const tx = await contract.lockAndSend(
    chainSelector,
    tokenId,
    "0x0000000000000000000000000000000000000000"
  );

  const receipt = await tx.wait();

  return receipt;
}