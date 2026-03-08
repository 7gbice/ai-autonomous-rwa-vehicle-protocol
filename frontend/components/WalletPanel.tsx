"use client";
import React from "react";

export default function WalletPanel({ wallet, connectWallet }: { wallet: string; connectWallet: () => void }) {
  return (
    <div className="bg-gray-900 p-6 rounded">
      <h2 className="text-xl mb-2">Wallet</h2>
      {wallet ? <p>{wallet}</p> : (
        <button onClick={connectWallet} className="bg-blue-600 px-6 py-3 rounded">
          Connect Wallet
        </button>
      )}
    </div>
  );
}
