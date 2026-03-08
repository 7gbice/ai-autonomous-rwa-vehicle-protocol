"use client";
import React from "react";

export default function UnlockPanel({
  unlocks
}: {
  unlocks: { owner: string; tokenId: string; confirmedOwner: string }[];
}) {
  return (
    <div className="bg-gray-900 p-6 rounded">
      <h2 className="text-xl mb-2">Unlock Status</h2>
      {unlocks.length === 0 && <p>No unlock events yet</p>}
      {unlocks.map((u, i) => (
        <p key={i}>
          Car {u.tokenId} unlocked for {u.owner} — Confirmed owner: {u.confirmedOwner}
        </p>
      ))}
    </div>
  );
}
