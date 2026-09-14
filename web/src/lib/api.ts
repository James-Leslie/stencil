/**
 * Every call the browser app makes to FastAPI. Pages import this; components
 * never do.
 *
 * In dev, Vite proxies /api to :8000; in production the host routes it to the
 * backend. Either way it's the same origin, so a session cookie would ride
 * along without any CORS setup.
 */

export type Health = { status: string }

class ApiError extends Error {
  constructor(
    readonly status: number,
    message: string,
  ) {
    super(message)
  }
}

async function request<T>(path: string, init?: RequestInit): Promise<T> {
  const response = await fetch(`/api${path}`, {
    headers: { 'content-type': 'application/json' },
    ...init,
  })
  if (!response.ok) {
    throw new ApiError(response.status, `${init?.method ?? 'GET'} ${path} failed`)
  }
  return response.json() as Promise<T>
}

export const api = {
  health: () => request<Health>('/health'),
}

export function errorMessage(failure: unknown): string {
  return failure instanceof Error ? failure.message : String(failure)
}
