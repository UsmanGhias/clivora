import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { ListToolsRequestSchema, CallToolRequestSchema } from '@modelcontextprotocol/sdk/types.js';
import { randomBytes } from 'node:crypto';
import { supabase } from './supabase.js';

type Args = Record<string, unknown> | undefined;

const MAX_LIMIT = 100;

function text(value: unknown) {
  return { content: [{ type: 'text', text: typeof value === 'string' ? value : JSON.stringify(value, null, 2) }] };
}

function str(args: Args, key: string): string {
  const v = args?.[key];
  return typeof v === 'string' ? v.trim() : '';
}

function requireStr(args: Args, key: string): string {
  const v = str(args, key);
  if (!v) throw new Error(`"${key}" is required`);
  return v;
}

function clampLimit(value: unknown, fallback = 20): number {
  const n = Math.floor(Number(value));
  return Number.isFinite(n) && n > 0 ? Math.min(n, MAX_LIMIT) : fallback;
}

/** Escape a user term for PostgREST ilike filters (wildcards and the or() separators). */
function ilikeTerm(term: string): string {
  return `%${term.replace(/[\\%_]/g, (c) => `\\${c}`).replace(/[,()]/g, ' ')}%`;
}

/**
 * The service-role key bypasses RLS, so every CRM read/write must be scoped to an explicit owner.
 * CLIVORA_OWNER_UID pins the MCP server to one account.
 */
function ownerUid(): string {
  const uid = (process.env.CLIVORA_OWNER_UID || '').trim();
  if (!uid) throw new Error('CLIVORA_OWNER_UID is not set; CRM tools are disabled until it is configured.');
  return uid;
}

/** Same rounding as web/src/lib/money.ts toMinorUnits (exponent form avoids 1.005 * 100 drift). */
function toMinorUnits(amount: number): number {
  return Math.round(Number(`${amount}e2`));
}

function slugify(title: string): string {
  const base = title
    .toLowerCase()
    .normalize('NFKD')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .slice(0, 60);
  return `${base || 'job'}-${randomBytes(3).toString('hex')}`;
}

const TOOLS = [
  {
    name: 'clivora_list_jobs',
    description: 'Search published Connect marketplace jobs by keyword and/or category (newest first).',
    inputSchema: {
      type: 'object',
      properties: {
        query: { type: 'string', description: 'Keyword matched against title, company and description' },
        category: { type: 'string' },
        limit: { type: 'number', description: `Max results (default 20, max ${MAX_LIMIT})` },
      },
    },
  },
  {
    name: 'clivora_create_job',
    description: 'Create a manual job posting as an unpublished draft for review.',
    inputSchema: {
      type: 'object',
      properties: {
        title: { type: 'string' },
        company_name: { type: 'string' },
        description: { type: 'string' },
        category: { type: 'string' },
        tags: { type: 'array', items: { type: 'string' } },
        salary_min: { type: 'number' },
        salary_max: { type: 'number' },
        currency: { type: 'string' },
        location: { type: 'string' },
        job_type: { type: 'string', enum: ['full_time', 'part_time', 'contract', 'freelance', 'internship'] },
      },
      required: ['title', 'company_name', 'description'],
    },
  },
  {
    name: 'clivora_search_crm',
    description: "Keyword search across the configured owner's CRM customers, projects and invoices.",
    inputSchema: {
      type: 'object',
      properties: {
        query: { type: 'string' },
        entity_type: { type: 'string', enum: ['customers', 'projects', 'invoices'] },
        limit: { type: 'number' },
      },
      required: ['query'],
    },
  },
  {
    name: 'clivora_draft_proposal',
    description: 'Build a structured proposal outline from a job post and the freelancer skills that match it.',
    inputSchema: {
      type: 'object',
      properties: {
        job_title: { type: 'string' },
        job_description: { type: 'string' },
        freelancer_skills: { type: 'array', items: { type: 'string' } },
      },
      required: ['job_title', 'job_description'],
    },
  },
  {
    name: 'clivora_create_invoice',
    description: "Create a draft invoice for an existing CRM customer of the configured owner. Rates are in major units (e.g. 49.99).",
    inputSchema: {
      type: 'object',
      properties: {
        customer_name: { type: 'string', description: 'Matches the CRM contact person or company' },
        items: {
          type: 'array',
          items: {
            type: 'object',
            properties: {
              description: { type: 'string' },
              quantity: { type: 'number' },
              rate: { type: 'number' },
            },
            required: ['description', 'quantity', 'rate'],
          },
        },
        currency: { type: 'string' },
        due_date: { type: 'string', description: 'ISO date' },
      },
      required: ['customer_name', 'items'],
    },
  },
  {
    name: 'clivora_trigger_job_crawler',
    description: 'Ingest external job feeds (remotive, arbeitnow, hackernews).',
    inputSchema: {
      type: 'object',
      properties: {
        sources: { type: 'array', items: { type: 'string' } },
      },
    },
  },
  {
    name: 'clivora_sync_status',
    description: "Report cloud-side sync health: the owner's CRM rows not yet marked synced and the latest crawler ingest.",
    inputSchema: { type: 'object', properties: {} },
  },
];

async function listJobs(args: Args) {
  let query = supabase
    .from('connect_jobs')
    .select('id, title, company_name, category, tags, salary_min, salary_max, currency, location, job_type, seo_slug, source_url, created_at')
    .eq('status', 'published')
    .eq('is_public', true)
    .order('created_at', { ascending: false })
    .limit(clampLimit(args?.limit));
  const category = str(args, 'category');
  if (category) query = query.eq('category', category);
  const term = str(args, 'query');
  if (term) {
    const like = ilikeTerm(term);
    query = query.or(`title.ilike.${like},company_name.ilike.${like},description.ilike.${like}`);
  }
  const { data, error } = await query;
  if (error) throw error;
  return text(data);
}

async function createJob(args: Args) {
  const title = requireStr(args, 'title');
  const salaryMin = args?.salary_min == null ? null : Math.round(Number(args.salary_min));
  const salaryMax = args?.salary_max == null ? null : Math.round(Number(args.salary_max));
  if ((salaryMin != null && !Number.isFinite(salaryMin)) || (salaryMax != null && !Number.isFinite(salaryMax))) {
    throw new Error('salary_min and salary_max must be numbers');
  }
  if (salaryMin != null && salaryMax != null && salaryMin > salaryMax) {
    throw new Error('salary_min cannot exceed salary_max');
  }
  const tags = Array.isArray(args?.tags) ? args.tags.filter((t): t is string => typeof t === 'string' && t.trim() !== '').map((t) => t.trim()) : [];

  const row: Record<string, unknown> = {
    title,
    company_name: requireStr(args, 'company_name'),
    description: requireStr(args, 'description'),
    tags,
    salary_min: salaryMin,
    salary_max: salaryMax,
    seo_slug: slugify(title),
    source: 'manual',
    status: 'draft',
    is_public: false,
  };
  for (const key of ['category', 'currency', 'location', 'job_type']) {
    const v = str(args, key);
    if (v) row[key] = v;
  }

  const { data, error } = await supabase.from('connect_jobs').insert(row).select('id, seo_slug, status').single();
  if (error) throw error;
  return text({ message: 'Job created as an unpublished draft.', ...data });
}

async function searchCrm(args: Args) {
  const owner = ownerUid();
  const like = ilikeTerm(requireStr(args, 'query'));
  const limit = clampLimit(args?.limit, 10);
  const entity = str(args, 'entity_type');
  const results: Record<string, unknown> = {};

  if (!entity || entity === 'customers') {
    const { data, error } = await supabase
      .from('crm_customers')
      .select('id, contact_person, company, emails, city, country')
      .eq('owner_uid', owner)
      .or(`contact_person.ilike.${like},company.ilike.${like},notes.ilike.${like}`)
      .limit(limit);
    if (error) throw error;
    results.customers = data;
  }
  if (!entity || entity === 'projects') {
    const { data, error } = await supabase
      .from('crm_projects')
      .select('id, name, description, budget, currency, customer_id')
      .eq('owner_uid', owner)
      .or(`name.ilike.${like},description.ilike.${like}`)
      .limit(limit);
    if (error) throw error;
    results.projects = data;
  }
  if (!entity || entity === 'invoices') {
    const { data, error } = await supabase
      .from('crm_invoices')
      .select('id, invoice_number, status, total, total_minor, currency, due_date, customer_id')
      .eq('owner_uid', owner)
      .ilike('invoice_number', like)
      .limit(limit);
    if (error) throw error;
    results.invoices = data;
  }
  return text(results);
}

function draftProposal(args: Args) {
  const jobTitle = requireStr(args, 'job_title');
  const description = requireStr(args, 'job_description');
  const skills = Array.isArray(args?.freelancer_skills)
    ? args.freelancer_skills.filter((s): s is string => typeof s === 'string' && s.trim() !== '')
    : [];
  const haystack = description.toLowerCase();
  const matched = skills.filter((s) => haystack.includes(s.toLowerCase()));
  const other = skills.filter((s) => !matched.includes(s));

  return text({
    note: 'Outline assembled from the job post; no model was called. Rewrite each section in your own voice before sending.',
    job_title: jobTitle,
    matched_skills: matched,
    other_skills: other,
    outline: [
      `Opening: restate the core problem behind "${jobTitle}" in one or two sentences.`,
      matched.length
        ? `Fit: show recent work that used ${matched.join(', ')}.`
        : 'Fit: none of the listed skills appear in the post; name the closest relevant experience.',
      'Approach: two or three concrete steps for the first milestone.',
      'Timeline and budget: propose the first milestone with a clear deliverable.',
      'Close: one specific question about the project to start the conversation.',
    ],
  });
}

async function createInvoice(args: Args) {
  const owner = ownerUid();
  const customerName = requireStr(args, 'customer_name');
  const rawItems = Array.isArray(args?.items) ? args.items : [];
  if (rawItems.length === 0) throw new Error('"items" must contain at least one line item');

  const lineItems = rawItems.map((raw, i) => {
    const item = (raw ?? {}) as Record<string, unknown>;
    const description = typeof item.description === 'string' ? item.description.trim() : '';
    const quantity = Number(item.quantity);
    const rate = Number(item.rate);
    if (!description) throw new Error(`items[${i}].description is required`);
    if (!Number.isFinite(quantity) || quantity <= 0) throw new Error(`items[${i}].quantity must be greater than 0`);
    if (!Number.isFinite(rate) || rate < 0) throw new Error(`items[${i}].rate must be 0 or more`);
    const rateMinor = toMinorUnits(rate);
    return { description, quantity, unitPrice: rateMinor / 100, amountMinor: Math.round(quantity * rateMinor) };
  });

  const { data: customers, error: customerError } = await supabase
    .from('crm_customers')
    .select('id, contact_person, company')
    .eq('owner_uid', owner)
    .or(`contact_person.ilike.${ilikeTerm(customerName)},company.ilike.${ilikeTerm(customerName)}`)
    .limit(5);
  if (customerError) throw customerError;
  if (!customers?.length) throw new Error(`No CRM customer matches "${customerName}". Create the customer first.`);
  if (customers.length > 1) {
    throw new Error(`"${customerName}" matches ${customers.length} customers; use a more specific name: ${JSON.stringify(customers)}`);
  }

  // Integer minor-unit arithmetic; numeric columns are dual-written from the minor totals.
  const subtotalMinor = lineItems.reduce((sum, item) => sum + item.amountMinor, 0);
  const discountMinor = 0;
  const taxMinor = 0;
  const totalMinor = subtotalMinor - discountMinor + taxMinor;
  const stamp = new Date().toISOString().slice(0, 10).replace(/-/g, '');

  const row = {
    owner_uid: owner,
    customer_id: customers[0].id,
    invoice_number: `MCP-${stamp}-${randomBytes(2).toString('hex').toUpperCase()}`,
    status: 'draft',
    currency: str(args, 'currency') || 'USD',
    due_date: str(args, 'due_date') || null,
    line_items: lineItems.map(({ description, quantity, unitPrice }) => ({ description, quantity, unitPrice })),
    subtotal: subtotalMinor / 100,
    total: totalMinor / 100,
    subtotal_minor: subtotalMinor,
    discount_minor: discountMinor,
    tax_minor: taxMinor,
    total_minor: totalMinor,
    amount_paid_minor: 0,
    updated_at: new Date().toISOString(),
  };

  const { data, error } = await supabase
    .from('crm_invoices')
    .insert(row)
    .select('id, invoice_number, status, total_minor, currency')
    .single();
  if (error) throw error;
  return text({ message: 'Draft invoice created.', customer: customers[0], ...data });
}

async function triggerCrawler(args: Args) {
  const sources = Array.isArray(args?.sources) ? args.sources : undefined;
  const { data, error } = await supabase.functions.invoke('sync-external-jobs', { body: { sources } });
  if (error) throw error;
  return text({ message: 'Job crawler triggered.', result: data ?? null });
}

async function syncStatus() {
  const owner = ownerUid();
  const unsynced: Record<string, number | null> = {};
  for (const table of ['crm_customers', 'crm_projects', 'crm_invoices', 'crm_expenses', 'crm_notes']) {
    const { count, error } = await supabase
      .from(table)
      .select('id', { count: 'exact', head: true })
      .eq('owner_uid', owner)
      .neq('sync_status', 'synced');
    if (error) throw error;
    unsynced[table] = count;
  }

  const { data: lastCrawled, error: crawlError } = await supabase
    .from('connect_jobs')
    .select('source, created_at')
    .neq('source', 'manual')
    .order('created_at', { ascending: false })
    .limit(1)
    .maybeSingle();
  if (crawlError) throw crawlError;

  const pending = Object.values(unsynced).reduce<number>((sum, n) => sum + (n ?? 0), 0);
  return text({
    status: pending === 0 ? 'healthy' : 'pending_rows',
    unsynced_rows: unsynced,
    last_crawler_ingest: lastCrawled ?? null,
    note: "Device-side outbox queues are not visible from the server; this reflects cloud rows only.",
    timestamp: new Date().toISOString(),
  });
}

export function registerTools(server: Server) {
  server.setRequestHandler(ListToolsRequestSchema, async () => ({ tools: TOOLS }));

  server.setRequestHandler(CallToolRequestSchema, async (request) => {
    const { name, arguments: args } = request.params;
    try {
      switch (name) {
        case 'clivora_list_jobs':
          return await listJobs(args);
        case 'clivora_create_job':
          return await createJob(args);
        case 'clivora_search_crm':
          return await searchCrm(args);
        case 'clivora_draft_proposal':
          return draftProposal(args);
        case 'clivora_create_invoice':
          return await createInvoice(args);
        case 'clivora_trigger_job_crawler':
          return await triggerCrawler(args);
        case 'clivora_sync_status':
          return await syncStatus();
        default:
          throw new Error(`Unknown tool: ${name}`);
      }
    } catch (error: unknown) {
      const message = error instanceof Error ? error.message : (error as { message?: string })?.message ?? String(error);
      return { content: [{ type: 'text', text: `Error: ${message}` }], isError: true };
    }
  });
}
