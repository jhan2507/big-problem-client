import { request, HttpError } from './http';

export class ApiError extends Error {
  constructor(message: string, public status: number) {
    super(message);
    this.name = 'ApiError';
  }
}

export async function getHello({ baseUrl = '' }: { baseUrl?: string }): Promise<string> {
  const url = baseUrl ? `${baseUrl.replace(/\/$/, '')}/api/hello` : '/api/hello';
  try {
    return await request<string>(url, { method: 'GET', parseAs: 'text', timeoutMs: 8000 });
  } catch (e) {
    if (e instanceof HttpError) throw new ApiError('Failed to fetch hello', e.status);
    throw e;
  }
}
