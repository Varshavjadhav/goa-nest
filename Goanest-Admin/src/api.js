const API_BASE = (import.meta.env.VITE_API_BASE_URL || 'http://localhost:5001/api/v1').replace(/\/$/, '');

export async function api(path, { token, ...options } = {}) {
  const response = await fetch(`${API_BASE}${path}`, {
    ...options,
    headers: {
      Accept: 'application/json',
      ...(options.body ? { 'Content-Type': 'application/json' } : {}),
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...options.headers,
    },
  });
  const body = await response.json().catch(() => ({}));
  if (!response.ok || body.success === false) throw new Error(body.message || `Request failed (${response.status})`);
  return body.data ?? body;
}

export const apiBaseUrl = API_BASE;
