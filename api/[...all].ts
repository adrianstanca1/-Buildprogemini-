// Vercel Serverless Function - API Proxy
import type { VercelRequest, VercelResponse } from '@vercel/node';

// This will be replaced by the actual backend when deployed
export default async function handler(req: VercelRequest, res: VercelResponse) {
  // Import the Express app
  const app = await import('../backend/src/server');
  
  // Handle the request
  return app.default(req, res);
}
