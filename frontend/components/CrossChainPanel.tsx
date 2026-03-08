"use client";
import React from "react";
import { CHAINS } from "../config/chains";

export default function CrossChainPanel({
  destination,
  setDestination,
  lockCar,
  loading,
  switchChain,
  tokenId
}: {
  destination: string;
  setDestination: (d: string) => void;
  lockCar: () => void;
  loading: boolean;
  switchChain: (chainIdHex: string) => void;
  tokenId: number;
}) {
  return (
    <div className="bg-gray-900 p-6 rounded">
      <h2 className="text-xl mb-4">Cross-Chain Actions</h2>
      <select
        value={destination}
        onChange={(e) => {
          const selected = e.target.value;
          setDestination(selected);
          switchChain("0x" + CHAINS[selected].chainId.toString(16));
        }}
        className="bg-gray-800 text-white px-4 py-2 rounded mb-4"
      >
        {Object.keys(CHAINS).map((key) => (
          <option key={key} value={key}>
            {CHAINS[key].name} – {CHAINS[key].explorer.replace("https://","")}
          </option>
        ))}
      </select>
      <button
        onClick={lockCar}
        disabled={loading}
        className="bg-green-600 px-6 py-3 rounded"
      >
        {loading ? "Processing..." : `Lock & Send Car #${tokenId}`}
      </button>
    </div>
  );
}
