"use client";

import { useState, useEffect } from "react";
import WalletPanel from "../components/WalletPanel";
import BalancePanel from "../components/BalancePanel";
import CarNFTPanel from "../components/CarNFTPanel";
import CrossChainPanel from "../components/CrossChainPanel";
import StatusPanel from "../components/StatusPanel";
import EventLogPanel from "../components/EventLogPanel";
import toast from "react-hot-toast";
import UnlockPanel from "../components/UnlockPanel";

import {
  connectWallet,
  loadBalances,
  loadNFTData,
  mintCar,
  lockCar,
  listenForLockEvents,
  listenForUnlockEvents,
  validateLock
} from "../lib/contracts";

export default function Home() {
  // ---------------- State ----------------
  const [wallet, setWallet] = useState("");
  const [balances, setBalances] = useState<Record<string, string>>({});
  const [status, setStatus] = useState("");
  const [txHash, setTxHash] = useState("");
  const [events, setEvents] = useState<{ owner: string; tokenId: string }[]>([]);
  const [unlocks, setUnlocks] = useState<
    { owner: string; tokenId: string; confirmedOwner: string }[]
  >([]);
  const [destination, setDestination] = useState("Sepolia");
  const [tokenId, setTokenId] = useState(1);
  const [tokenOwner, setTokenOwner] = useState("");
  const [loading, setLoading] = useState(false);

  // ---------------- Actions ----------------
  // async function handleConnectWallet() {
  //   try {
  //     const address = await connectWallet();
  //     setWallet(address);
  //     setBalances(await loadBalances(address));
  //     setTokenOwner(await loadNFTData(tokenId));
  //   } catch (err) {
  //     console.error(err);
  //     setStatus("Wallet connection failed ❌");
  //   }
  // }

  // async function handleMintCar() {
  //   try {
  //     if (!wallet) {
  //       setStatus("Connect your wallet first ❌");
  //       return;
  //     }
  //     setLoading(true);
  //     setStatus("Minting new Car NFT...");
  //     const txHash = await mintCar(wallet);
  //     setTxHash(txHash);
  //     setStatus(`Car NFT minted for ${wallet}`);
  //     setTokenOwner(await loadNFTData(tokenId));
  //     setBalances(await loadBalances(wallet));
  //   } catch (err) {
  //     console.error(err);
  //     setStatus("Mint failed ❌");
  //   } finally {
  //     setLoading(false);
  //   }
  // }

  /////////////////////////////////
  async function handleConnectWallet() {
  try {
    toast.loading("Connecting wallet...");
    const address = await connectWallet();
    setWallet(address);
    setBalances(await loadBalances(address));
    setTokenOwner(await loadNFTData(tokenId));
    toast.success(`Wallet connected: ${address}`);
  } catch (err) {
    console.error(err);
    toast.error("Wallet connection failed ❌");
  } finally {
    toast.dismiss(); // clear loading toast
  }
}

async function handleMintCar() {
  try {
    if (!wallet) {
      toast.error("Connect your wallet first ❌");
      return;
    }
    setLoading(true);
    toast.loading("Minting new Car NFT...");
    const txHash = await mintCar(wallet);
    setTxHash(txHash);
    setTokenOwner(await loadNFTData(tokenId));
    setBalances(await loadBalances(wallet));
    toast.success(`Car NFT minted for ${wallet} 🚗`);
  } catch (err) {
    console.error(err);
    toast.error("Mint failed ❌");
  } finally {
    setLoading(false);
    toast.dismiss();
  }
}

async function handleLockCar() {
  try {
    setLoading(true);
    toast.loading("Validating lock...");

    const result = await validateLock(destination, tokenId, wallet);
    if (!result.valid) {
      toast.error(result.reason ?? "Validation failed ❌");
      setLoading(false);
      return;
    }

    toast.loading("Locking car...");
    const txHash = await lockCar(result.selector!, tokenId, wallet);
    setTxHash(txHash);
    setTokenOwner(await loadNFTData(tokenId));
    toast.success(`Car #${tokenId} locked → ${destination} 🚀`);
  } catch (err) {
    console.error(err);
    toast.error("Lock failed ❌");
  } finally {
    setLoading(false);
    toast.dismiss();
  }
}
  /////////////////////////////////////////////////

  // async function handleLockCar() {
  //   try {
  //     setLoading(true);
  //     setStatus("Validating lock...");

  //     const result = await validateLock(destination, tokenId, wallet);
  //     if (!result.valid) {
  //       setStatus(result.reason ?? "Validation failed ❌");
  //       setLoading(false);
  //       return;
  //     }

  //     setStatus("Locking car...");
  //     const txHash = await lockCar(result.selector!, tokenId, wallet);
  //     setTxHash(txHash);
  //     setStatus(`Car #${tokenId} locked → ${destination}`);
  //     setTokenOwner(await loadNFTData(tokenId));
  //   } catch (err) {
  //     console.error(err);
  //     setStatus("Lock failed ❌");
  //   } finally {
  //     setLoading(false);
  //   }
  // }

  async function refreshDashboard() {
    if (!wallet) {
      setStatus("Connect your wallet first");
      return;
    }
    try {
      setLoading(true);
      setStatus("Refreshing dashboard...");
      setBalances(await loadBalances(wallet));
      setTokenOwner(await loadNFTData(tokenId));
      setEvents([]);
      setUnlocks([]);
      setStatus("Dashboard refreshed ✅");
    } catch (err) {
      console.error(err);
      setStatus("Refresh failed ❌");
    } finally {
      setLoading(false);
    }
  }

  // ---------------- Event Listeners ----------------
  useEffect(() => {
    let stopLock: (() => void) | undefined;
    let stopUnlock: (() => void) | undefined;

    (async () => {
      stopLock = await listenForLockEvents((owner, tokenId) => {
        setEvents((prev) => [...prev, { owner, tokenId }]);
        setStatus(`Car ${tokenId} locked by ${owner}`);
      });

      stopUnlock = await listenForUnlockEvents(destination, (owner, tokenId, confirmedOwner) => {
        setUnlocks((prev) => [...prev, { owner, tokenId, confirmedOwner }]);
        setStatus(`Car ${tokenId} unlocked for ${owner}`);
      });
    })();

    return () => {
      stopLock?.();
      stopUnlock?.();
    };
  }, [destination]);

  // ---------------- UI ----------------
  return (
    <main className="min-h-screen p-10 bg-black text-white space-y-6">
      <h1 className="text-4xl mb-6">AI Autonomous RWA Vehicle Protocol</h1>

      <button
        onClick={refreshDashboard}
        disabled={loading}
        className="bg-yellow-600 px-6 py-3 rounded"
      >
        {loading ? "Refreshing..." : "Refresh Dashboard"}
      </button>

      <WalletPanel wallet={wallet} connectWallet={handleConnectWallet} />
      <BalancePanel balances={balances} refresh={() => loadBalances(wallet).then(setBalances)} />
      <CarNFTPanel
        tokenId={tokenId}
        setTokenId={setTokenId}
        tokenOwner={tokenOwner}
        mintCar={handleMintCar}
        loading={loading}
      />
      <CrossChainPanel
        destination={destination}
        setDestination={setDestination}
        lockCar={handleLockCar}
        loading={loading}
        switchChain={() => { /* optional chain switch logic */ }}
        tokenId={tokenId}
      />

      <StatusPanel status={status} txHash={txHash} destination={destination} />
      <EventLogPanel events={events} />
      <UnlockPanel unlocks={unlocks} />
    </main>
  );
}
