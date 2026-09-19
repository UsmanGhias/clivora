#!/usr/bin/env node
import 'dotenv/config';
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { registerTools } from './tools.js';

function createServer() {
  const server = new Server(
    { name: 'clivora-mcp', version: '1.0.0' },
    { capabilities: { tools: {} } }
  );
  registerTools(server);
  return server;
}

async function main() {
  const args = process.argv.slice(2);
  if (args.includes('--http')) {
    // HTTP/SSE transport for web-based clients
    const { SSEServerTransport } = await import('@modelcontextprotocol/sdk/server/sse.js');
    const http = await import('node:http');
    const PORT = parseInt(process.env.MCP_PORT || '3333', 10);
    // This process holds the service-role key and has no auth of its own: stay on loopback
    // unless MCP_HOST is set deliberately.
    const HOST = process.env.MCP_HOST || '127.0.0.1';

    // One transport + server per SSE session; clients POST to /message?sessionId=<id>.
    const sessions = new Map<string, InstanceType<typeof SSEServerTransport>>();

    const httpServer = http.createServer((req, res) => {
      const url = new URL(req.url ?? '/', 'http://localhost');
      if (req.method === 'GET' && url.pathname === '/sse') {
        const transport = new SSEServerTransport('/message', res);
        sessions.set(transport.sessionId, transport);
        res.on('close', () => sessions.delete(transport.sessionId));
        createServer().connect(transport).catch((err) => {
          console.error('MCP session failed to start:', err);
          sessions.delete(transport.sessionId);
        });
      } else if (req.method === 'POST' && url.pathname === '/message') {
        const transport = sessions.get(url.searchParams.get('sessionId') ?? '');
        if (transport) {
          transport.handlePostMessage(req, res).catch((err) => console.error('MCP message failed:', err));
        } else {
          res.writeHead(404);
          res.end('Unknown or expired session');
        }
      } else {
        res.writeHead(404);
        res.end();
      }
    });

    httpServer.listen(PORT, HOST, () => {
      console.log(`CLIVORA MCP HTTP/SSE server running on http://${HOST}:${PORT}`);
    });
  } else {
    // Default: stdio transport
    const transport = new StdioServerTransport();
    await createServer().connect(transport);
  }
}

main().catch(console.error);
