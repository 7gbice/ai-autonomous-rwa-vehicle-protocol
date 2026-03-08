"use client";
import React from "react";
import { CHAINS } from "../config/chains";

export default function BalancePanel({ balances, refresh }: { balances: Record<string, string>; refresh: () => void }) {
  return (
    <div className="bg-gray-900 p-6 rounded">
      <h2 className="text-xl mb-2">Multi‑Chain NFT Balances</h2>
      {Object.keys(CHAINS).map((key) => (
        <p key={key}>
          {CHAINS[key].name}: {balances[key] ?? "Loading..."}
        </p>
      ))}
      <button onClick={refresh} className="bg-blue-600 px-4 py-2 rounded mt-2">
        Refresh Balances
      </button>
    </div>
  );
}
