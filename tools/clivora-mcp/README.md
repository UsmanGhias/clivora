# CLIVORA MCP Server

AI-powered freelancer business OS tools via Model Context Protocol.

## Tools
- `clivora_list_jobs`: Keyword/category search over published Connect jobs
- `clivora_create_job`: Create a job as an unpublished draft (`status: draft`, `is_public: false`)
- `clivora_search_crm`: Keyword search over the owner's customers, projects and invoices
- `clivora_draft_proposal`: Structured proposal outline from a job post (no model call)
- `clivora_create_invoice`: Draft invoice for an existing CRM customer (integer minor-unit totals)
- `clivora_trigger_job_crawler`: Invoke the `sync-external-jobs` edge function
- `clivora_sync_status`: Owner's CRM rows not yet synced + latest crawler ingest

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
        "CLIVORA_OWNER_UID": "auth-user-uuid-whose-crm-this-server-manages"
      }
    }
  }
}
```

The service-role key bypasses RLS, so the CRM tools (`search_crm`, `create_invoice`,
`sync_status`) only touch rows where `owner_uid = CLIVORA_OWNER_UID` and refuse to run without it.

`--http` serves SSE on `127.0.0.1:3333` (`MCP_HOST` / `MCP_PORT` to override). It has no
authentication of its own, so do not bind it to a public interface.

## Development

```bash
npm install
npm run dev
npm run build
```
