"use client";
import React from "react";

export default function EventLogPanel({ events }: { events: { owner: string; tokenId: string }[] }) {
  return (
    <div className="bg-gray-900 p-6 rounded">
      <h2 className="text-xl mb-2">Event Log</h2>
      {events.length === 0 && <p>No lock events yet</p>}
      {events.map((e, i) => (
        <p key={i}>Car {e.tokenId} locked by {e.owner}</p>
      ))}
    </div>
  );
}
