import { getHello, ApiError } from './api-client';

describe('getHello', () => {
  beforeEach(() => {
    // @ts-ignore
    global.fetch = jest.fn().mockResolvedValue({
      ok: true,
      headers: { get: () => 'text/plain' },
      text: () => Promise.resolve('Hello, from API!'),
    });
  });

  it('returns text from API', async () => {
    const result = await getHello({ baseUrl: 'http://localhost:3000' });
    expect(result).toBe('Hello, from API!');
    expect(global.fetch).toHaveBeenCalledWith(
      'http://localhost:3000/api/hello',
      expect.objectContaining({ method: 'GET' })
    );
  });

  it('throws ApiError on non-ok response', async () => {
    // @ts-ignore
    global.fetch = jest.fn().mockResolvedValue({
      ok: false,
      status: 500,
      headers: { get: () => 'text/plain' },
      text: () => Promise.resolve(''),
    });
    await expect(getHello({ baseUrl: 'http://localhost:3000' })).rejects.toBeInstanceOf(ApiError);
  });

  it('maps AbortError to ApiError (simulated timeout)', async () => {
    // @ts-ignore
    global.fetch = jest.fn().mockRejectedValue({ name: 'AbortError' });
    await expect(getHello({ baseUrl: 'http://localhost:3000' })).rejects.toBeInstanceOf(ApiError);
  });
});
