"use client";
import React from "react";
import { CHAINS } from "../config/chains";

export default function StatusPanel({
  status,
  txHash,
  destination
}: {
  status: string;
  txHash: string;
  destination: string;
}) {
  return (
    <div className="bg-gray-900 p-6 rounded">
      <h2 className="text-xl mb-2">Status</h2>
      <p>{status}</p>
      {txHash && (
        <p className="text-green-400 mt-4">
          Tx:
          <a
            className="underline ml-2"
            target="_blank"
            href={`${CHAINS[destination].explorer}/tx/${txHash}`}
          >
            View on {CHAINS[destination].name} Explorer
          </a>
        </p>
      )}
    </div>
  );
}
