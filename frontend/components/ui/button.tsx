"use client";
import React from "react";
import clsx from "clsx";

export function Button({ children, className, variant = "default", ...props }) {
  const base = "px-4 py-2 font-medium focus:outline-none transition";
  const styles = {
    default: "bg-blue-600 text-white hover:bg-blue-700",
    secondary: "bg-gray-600 text-white hover:bg-gray-700",
    outline: "border border-gray-400 text-gray-200 hover:bg-gray-800",
  };

  return (
    <button className={clsx(base, styles[variant], className)} {...props}>
      {children}
    </button>
  );
}
