# CLIVORA MCP Server

AI-powered freelancer business OS tools via Model Context Protocol.

## Tools
- `clivora_list_jobs`: Search Connect marketplace jobs
- `clivora_create_job`: Post a new job
- `clivora_search_crm`: Semantic search across CRM
- `clivora_draft_proposal`: Generate tailored proposals
- `clivora_create_invoice`: Generate invoices
- `clivora_trigger_job_crawler`: Ingest external job feeds
- `clivora_sync_status`: Check sync health

## Configuration

Add this to your Claude Desktop config (or Cursor config):

```json
{
  "mcpServers": {
    "clivora-mcp": {
      "command": "node",
      "args": ["/absolute/path/to/clivora/Clivora/tools/clivora-mcp/dist/index.js"],
      "env": {
        "SUPABASE_URL": "https://your-project.supabase.co",
        "SUPABASE_SERVICE_ROLE_KEY": "your-service-role-key",
        "GEMINI_API_KEY": "your-gemini-api-key"
      }
    }
  }
}
```

## Development

```bash
npm install
npm run dev
npm run build
```
