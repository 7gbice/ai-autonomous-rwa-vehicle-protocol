"use client";
import React from "react";

export function Card({ children, className }) {
  return (
    <div className={`rounded-xl border border-gray-700 bg-gray-900 ${className}`}>
      {children}
    </div>
  );
}

export function CardContent({ children, className }) {
  return <div className={`p-4 ${className}`}>{children}</div>;
}
