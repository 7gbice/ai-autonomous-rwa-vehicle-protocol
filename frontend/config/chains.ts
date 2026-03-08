export const CHAINS: Record<string, {
  name: string;
  chainId: number;
  selector: bigint;
  rpcUrl: string;
  explorer: string;
}> = {
  Fuji: {
    name: "Avalanche Fuji",
    chainId: 43113,
    selector: BigInt(process.env.NEXT_PUBLIC_CHAIN_SELECTOR_FUJI!),
    rpcUrl: process.env.NEXT_PUBLIC_FUJI_RPC_URL!,
    explorer: "https://testnet.snowtrace.io"
  },
  Sepolia: {
    name: "Ethereum Sepolia",
    chainId: 11155111,
    selector: BigInt(process.env.NEXT_PUBLIC_CHAIN_SELECTOR_SEPOLIA!),
    rpcUrl: process.env.NEXT_PUBLIC_SEPOLIA_RPC_URL!,
    explorer: "https://sepolia.etherscan.io"
  },
  Mumbai: {
    name: "Polygon Mumbai",
    chainId: 80001,
    selector: BigInt(process.env.NEXT_PUBLIC_CHAIN_SELECTOR_MUMBAI!),
    rpcUrl: process.env.NEXT_PUBLIC_MUMBAI_RPC_URL!,
    explorer: "https://mumbai.polygonscan.com"
  },
  ArbitrumSepolia: {
    name: "Arbitrum Sepolia",
    chainId: 421614,
    selector: BigInt(process.env.NEXT_PUBLIC_CHAIN_SELECTOR_ARBITRUM_SEPOLIA!),
    rpcUrl: process.env.NEXT_PUBLIC_ARBITRUM_SEPOLIA_RPC_URL!,
    explorer: "https://sepolia.arbiscan.io"
  },
  OptimismSepolia: {
    name: "Optimism Sepolia",
    chainId: 11155420,
    selector: BigInt(process.env.NEXT_PUBLIC_CHAIN_SELECTOR_OPTIMISM_SEPOLIA!),
    rpcUrl: process.env.NEXT_PUBLIC_OPTIMISM_SEPOLIA_RPC_URL!,
    explorer: "https://sepolia-optimism.etherscan.io"
  },
  BaseSepolia: {
    name: "Base Sepolia",
    chainId: 84532,
    selector: BigInt(process.env.NEXT_PUBLIC_CHAIN_SELECTOR_BASE_SEPOLIA!),
    rpcUrl: process.env.NEXT_PUBLIC_BASE_SEPOLIA_RPC_URL!,
    explorer: "https://sepolia.basescan.org"
  }
};
