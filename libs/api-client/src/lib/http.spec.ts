import { request, HttpError } from './http';

describe('http request', () => {
  beforeEach(() => {
    // @ts-ignore
    global.fetch = jest.fn();
    jest.useFakeTimers();
  });

  afterEach(() => {
    jest.useRealTimers();
  });

  it('throws HttpError on AbortError (simulated timeout)', async () => {
    // @ts-ignore
    global.fetch.mockRejectedValue({ name: 'AbortError' });
    await expect(request('http://localhost/test', { timeoutMs: 10 })).rejects.toBeInstanceOf(HttpError);
  });

  it('retries on 5xx then succeeds', async () => {
    // @ts-ignore
    global.fetch.mockResolvedValueOnce({ ok: false, status: 500, headers: { get: () => 'application/json' } });
    // @ts-ignore
    global.fetch.mockResolvedValueOnce({ ok: true, headers: { get: () => 'application/json' }, json: async () => ({ ok: true }) });
    const res = await request('http://localhost/test', { retries: 1 });
    expect(res).toEqual({ ok: true });
  });
});
