export default function Loading() {
  return (
    <div className="mx-auto max-w-3xl px-4 py-8">
      <div className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
        <div className="h-6 w-48 animate-pulse rounded bg-slate-200" />
        <div className="mt-4 h-4 w-64 animate-pulse rounded bg-slate-200" />
        <div className="mt-4 flex gap-3">
          <div className="h-9 w-24 animate-pulse rounded bg-slate-200" />
          <div className="h-9 w-24 animate-pulse rounded bg-slate-200" />
        </div>
      </div>
    </div>
  );
}

