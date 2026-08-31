export default function handler(req, res) {
  res.setHeader('Cache-Control', 'no-store');

  if (req.method === 'GET') {
    return res.status(200).json({
      ok: true,
      service: 'shamara-gateway',
      mode: 'status-only',
      version: 1
    });
  }

  if (req.method !== 'POST') {
    res.setHeader('Allow', 'GET, POST');
    return res.status(405).json({ ok: false, error: 'method_not_allowed' });
  }

  const body = typeof req.body === 'object' && req.body !== null ? req.body : {};
  const allowed = {
    channel: String(body.channel || '').slice(0, 64),
    commandId: String(body.commandId || '').slice(0, 128),
    status: String(body.status || '').slice(0, 64),
    message: String(body.message || '').slice(0, 512),
    app: String(body.app || 'Drift').slice(0, 64),
    platform: String(body.platform || 'android').slice(0, 32),
    ts: String(body.ts || new Date().toISOString()).slice(0, 64)
  };

  if (allowed.channel !== 'shamara-v1' || !allowed.commandId || !allowed.status) {
    return res.status(400).json({ ok: false, error: 'invalid_status_payload' });
  }

  console.log(JSON.stringify({ type: 'SHAMARA_BRIDGE_STATUS', ...allowed }));
  return res.status(202).json({ ok: true, accepted: true, commandId: allowed.commandId });
}
