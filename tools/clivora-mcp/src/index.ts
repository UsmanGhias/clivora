#!/usr/bin/env node
import 'dotenv/config';
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { registerTools } from './tools.js';

const server = new Server(
  { name: 'clivora-mcp', version: '1.0.0' },
  { capabilities: { tools: {} } }
);

registerTools(server);

async function main() {
  const args = process.argv.slice(2);
  if (args.includes('--http')) {
    // HTTP/SSE transport for web-based clients
    const { SSEServerTransport } = await import('@modelcontextprotocol/sdk/server/sse.js');
    const http = await import('node:http');
    const PORT = parseInt(process.env.MCP_PORT || '3333', 10);
    
    let transport: any;
    const httpServer = http.createServer((req, res) => {
      if (req.url === '/sse') {
        transport = new SSEServerTransport('/message', res);
        server.connect(transport);
      } else if (req.url === '/message') {
        if (transport) {
          transport.handlePostMessage(req, res);
        } else {
          res.writeHead(500);
          res.end('SSE not initialized');
        }
      } else {
        res.writeHead(404);
        res.end();
      }
    });

    httpServer.listen(PORT, () => {
      console.log(`CLIVORA MCP HTTP/SSE server running on port ${PORT}`);
    });
  } else {
    // Default: stdio transport
    const transport = new StdioServerTransport();
    await server.connect(transport);
  }
}

main().catch(console.error);
