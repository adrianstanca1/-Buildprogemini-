// Vercel Serverless Function - API Proxy
import type { VercelRequest, VercelResponse } from '@vercel/node';
import app from '../backend/src/server.js';

export default async function handler(req: VercelRequest, res: VercelResponse) {
  // Let Express handle the request
  return app(req, res);
}
