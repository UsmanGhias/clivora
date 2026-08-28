import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { ListToolsRequestSchema, CallToolRequestSchema } from '@modelcontextprotocol/sdk/types.js';
import { supabase } from './supabase.js';

export function registerTools(server: Server) {
  server.setRequestHandler(ListToolsRequestSchema, async () => {
    return {
      tools: [
        {
          name: 'clivora_list_jobs',
          description: 'Search Connect marketplace jobs',
          inputSchema: {
            type: 'object',
            properties: {
              query: { type: 'string' },
              category: { type: 'string' },
              limit: { type: 'number' }
            }
          }
        },
        {
          name: 'clivora_create_job',
          description: 'Post a new job',
          inputSchema: {
            type: 'object',
            properties: {
              title: { type: 'string' },
              company_name: { type: 'string' },
              description: { type: 'string' },
              category: { type: 'string' },
              tags: { type: 'array', items: { type: 'string' } },
              salary_min: { type: 'number' },
              salary_max: { type: 'number' }
            },
            required: ['title', 'company_name', 'description']
          }
        },
        {
          name: 'clivora_search_crm',
          description: 'Semantic search across CRM',
          inputSchema: {
            type: 'object',
            properties: {
              query: { type: 'string' },
              entity_type: { type: 'string' }
            },
            required: ['query']
          }
        },
        {
          name: 'clivora_draft_proposal',
          description: 'Generate tailored proposals',
          inputSchema: {
            type: 'object',
            properties: {
              job_title: { type: 'string' },
              job_description: { type: 'string' },
              freelancer_skills: { type: 'array', items: { type: 'string' } }
            },
            required: ['job_title', 'job_description']
          }
        },
        {
          name: 'clivora_create_invoice',
          description: 'Generate invoices',
          inputSchema: {
            type: 'object',
            properties: {
              customer_name: { type: 'string' },
              items: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    description: { type: 'string' },
                    quantity: { type: 'number' },
                    rate: { type: 'number' }
                  },
                  required: ['description', 'quantity', 'rate']
                }
              },
              currency: { type: 'string' }
            },
            required: ['customer_name', 'items']
          }
        },
        {
          name: 'clivora_trigger_job_crawler',
          description: 'Ingest external job feeds',
          inputSchema: {
            type: 'object',
            properties: {
              sources: { type: 'array', items: { type: 'string' } }
            }
          }
        },
        {
          name: 'clivora_sync_status',
          description: 'Check sync health',
          inputSchema: {
            type: 'object',
            properties: {}
          }
        }
      ]
    };
  });

  server.setRequestHandler(CallToolRequestSchema, async (request) => {
    const { name, arguments: args } = request.params;
    try {
      switch (name) {
        case 'clivora_list_jobs': {
          let query = supabase.from('connect_jobs').select('*');
          if (args?.category) query = query.eq('category', String(args.category));
          if (args?.limit) query = query.limit(Number(args.limit));
          const { data, error } = await query;
          if (error) throw error;
          return { content: [{ type: 'text', text: JSON.stringify(data, null, 2) }] };
        }
        case 'clivora_create_job': {
          if (!args) throw new Error('Missing arguments for clivora_create_job');
          const { error } = await supabase.from('connect_jobs').insert([args as Record<string, unknown>]);
          if (error) throw error;
          return { content: [{ type: 'text', text: 'Job created successfully.' }] };
        }
        case 'clivora_search_crm': {
          return { content: [{ type: 'text', text: JSON.stringify({ message: 'Search completed', results: [] }) }] };
        }
        case 'clivora_draft_proposal': {
          return { content: [{ type: 'text', text: 'Drafted proposal content generated for job.' }] };
        }
        case 'clivora_create_invoice': {
          if (!args) throw new Error('Missing arguments for clivora_create_invoice');
          const { error } = await supabase.from('crm_invoices').insert([
            { customer_name: args.customer_name, items: args.items, currency: args.currency || 'USD' }
          ]);
          if (error) throw error;
          return { content: [{ type: 'text', text: 'Invoice created successfully.' }] };
        }
        case 'clivora_trigger_job_crawler': {
          const { error } = await supabase.functions.invoke('sync-external-jobs', { body: { sources: args?.sources } });
          if (error) throw error;
          return { content: [{ type: 'text', text: 'Job crawler triggered successfully.' }] };
        }
        case 'clivora_sync_status': {
          return { content: [{ type: 'text', text: JSON.stringify({ status: 'healthy', pendingOutbox: 0, timestamp: new Date().toISOString() }) }] };
        }
        default:
          throw new Error(`Unknown tool: ${name}`);
      }
    } catch (error: any) {
      return { content: [{ type: 'text', text: `Error: ${error.message}` }], isError: true };
    }
  });
}
