export class HttpError extends Error {
  constructor(
    message: string,
    public status: number,
    public url: string,
    public cause?: unknown
  ) {
    super(message);
    this.name = 'HttpError';
  }
}

export type RequestOptions = Omit<RequestInit, 'signal'> & {
  timeoutMs?: number;
  retries?: number;
  parseAs?: 'json' | 'text';
};

async function doFetch(input: string, init: RequestInit, timeoutMs?: number): Promise<Response> {
  if (!timeoutMs || timeoutMs <= 0) return fetch(input, init);
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), timeoutMs);
  try {
    const res = await fetch(input, { ...init, signal: controller.signal });
    clearTimeout(timer);
    return res;
  } catch (err) {
    clearTimeout(timer);
    throw err;
  }
}

export async function request<T = unknown>(input: string, options: RequestOptions = {}): Promise<T> {
  const { timeoutMs = 10000, retries = 0, parseAs } = options;
  const headers: Record<string, string> = {
    ...(options.headers as Record<string, string>),
  };
  const accept = headers['Accept'] || headers['accept'] || (parseAs === 'text' ? 'text/plain' : 'application/json');
  headers['Accept'] = accept;

  let attempt = 0;
  // Basic retry on network error and 5xx
  // No retry on 4xx
  while (true) {
    try {
      const res = await doFetch(input, { ...options, headers }, timeoutMs);
      if (!res.ok) {
        if (res.status >= 500 && attempt < retries) {
          attempt++;
          continue;
        }
        const msg = `HTTP ${res.status} when calling ${input}`;
        throw new HttpError(msg, res.status, input);
      }
      const ct = res.headers.get('content-type') || '';
      const shouldText = parseAs === 'text' || ct.includes('text/');
      const data = shouldText ? ((await res.text()) as unknown as T) : ((await res.json()) as T);
      return data;
    } catch (err: any) {
      const isAbort = err?.name === 'AbortError';
      const isNetwork = err instanceof TypeError || isAbort;
      if (isNetwork && attempt < retries) {
        attempt++;
        continue;
      }
      if (err instanceof HttpError) throw err;
      throw new HttpError('Network error', 0, input, err);
    }
  }
}

