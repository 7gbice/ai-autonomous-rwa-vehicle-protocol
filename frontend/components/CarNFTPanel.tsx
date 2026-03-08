"use client";
import React from "react";

export default function CarNFTPanel({
  tokenId,
  setTokenId,
  tokenOwner,
  mintCar,
  loading
}: {
  tokenId: number;
  setTokenId: (id: number) => void;
  tokenOwner: string;
  mintCar: () => void;
  loading: boolean;
}) {
  return (
    <div className="bg-gray-900 p-6 rounded">
      <h2 className="text-xl mb-2">Car NFT</h2>
      <input
        type="number"
        value={tokenId}
        onChange={(e) => setTokenId(Number(e.target.value))}
        className="bg-gray-800 text-white px-4 py-2 rounded mb-4"
        placeholder="Enter Token ID"
      />
      <p>Owner: {tokenOwner}</p>
      <button
        onClick={mintCar}
        disabled={loading}
        className="bg-purple-600 px-6 py-3 rounded mt-2"
      >
        Mint New Car NFT
      </button>
    </div>
  );
}
