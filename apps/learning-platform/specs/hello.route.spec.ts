/** @jest-environment node */
import { GET } from '../app/api/hello/route';

describe('GET /api/hello', () => {
  it('returns hello text', async () => {
    const res = await GET(new Request('http://localhost/api/hello'));
    const text = await res.text();
    expect(text).toBe('Hello, from API!');
  });
});
