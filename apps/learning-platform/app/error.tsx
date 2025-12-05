"use client";
import React from 'react';

export default function Error({ error, reset }: { error: Error; reset: () => void }) {
  return (
    <div className="mx-auto max-w-3xl px-4 py-8">
      <div className="rounded-2xl border border-red-200 bg-red-50 p-6 text-red-800">
        <h2 className="text-2xl font-semibold">Đã xảy ra lỗi</h2>
        <p className="mt-2 font-mono">{error.message}</p>
        <button
          className="mt-4 inline-flex items-center rounded-lg bg-red-600 px-4 py-2 text-white hover:bg-red-700"
          onClick={() => reset()}
        >
          Thử lại
        </button>
      </div>
    </div>
  );
}

