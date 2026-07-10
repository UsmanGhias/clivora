"use client";

import { FormEvent, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import {
  deleteCrmRow,
  upsertCustomerClient,
  upsertInvoiceClient,
  upsertProjectClient,
  asStringList,
  type CrmCustomer,
  type CrmInvoice,
  type CrmProject,
} from "@/lib/crm/api";

export function CustomersCrmPanel({
  initial,
  canCreate,
  gateReason,
  upgradeHref,
}: {
  initial: CrmCustomer[];
  canCreate: boolean;
  gateReason?: string;
  upgradeHref?: string;
}) {
  const router = useRouter();
  const [rows, setRows] = useState(initial);
  const [name, setName] = useState("");
  const [company, setCompany] = useState("");
  const [email, setEmail] = useState("");
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function onCreate(e: FormEvent) {
    e.preventDefault();
    if (!canCreate) return;
    setBusy(true);
    setError(null);
    try {
      const id = await upsertCustomerClient({
        contact_person: name,
        company,
        emails: email.trim() ? [email.trim().toLowerCase()] : [],
      });
      setRows((prev) => [
        {
          id,
          owner_uid: "",
          local_id: null,
          contact_person: name.trim(),
          company: company.trim(),
          emails: email.trim() ? [email.trim().toLowerCase()] : [],
          phones: [],
          whatsapp: "",
          address: "",
          city: "",
          postal_code: "",
          country: "",
          notes: "",
          status: "active",
          updated_at: new Date().toISOString(),
        },
        ...prev,
      ]);
      setName("");
      setCompany("");
      setEmail("");
      router.refresh();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Could not save client");
    } finally {
      setBusy(false);
    }
  }

  async function onDelete(id: string) {
    if (!confirm("Delete this client from cloud CRM?")) return;
    setBusy(true);
    try {
      await deleteCrmRow("crm_customers", id);
      setRows((prev) => prev.filter((r) => r.id !== id));
      router.refresh();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Delete failed");
    } finally {
      setBusy(false);
    }
  }

  return (
    <div className="space-y-4">
      <form onSubmit={onCreate} className="rounded-2xl border border-border bg-surface p-4 space-y-3">
        <p className="text-sm font-semibold text-navy">Add client (cloud)</p>
        {!canCreate && (
          <p className="rounded-lg bg-primary/10 px-3 py-2 text-sm text-navy">
            {gateReason}{" "}
            {upgradeHref && (
              <Link href={upgradeHref} className="font-semibold text-primary underline">
                Upgrade
              </Link>
            )}
          </p>
        )}
        <div className="grid gap-2 sm:grid-cols-3">
          <input
            required
            disabled={!canCreate || busy}
            placeholder="Contact name"
            value={name}
            onChange={(e) => setName(e.target.value)}
            className="rounded-xl border border-border px-3 py-2 text-sm"
          />
          <input
            disabled={!canCreate || busy}
            placeholder="Company"
            value={company}
            onChange={(e) => setCompany(e.target.value)}
            className="rounded-xl border border-border px-3 py-2 text-sm"
          />
          <input
            type="email"
            disabled={!canCreate || busy}
            placeholder="Email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className="rounded-xl border border-border px-3 py-2 text-sm"
          />
        </div>
        {error && <p className="text-sm text-error">{error}</p>}
        <button
          type="submit"
          disabled={!canCreate || busy}
          className="rounded-full bg-navy px-4 py-2 text-sm font-semibold text-white disabled:opacity-50"
        >
          {busy ? "Saving…" : "Save client"}
        </button>
      </form>

      {rows.length === 0 ? (
        <div className="rounded-2xl border border-dashed border-border bg-surface p-8 text-center">
          <p className="font-semibold">No cloud clients yet</p>
          <p className="mt-2 text-sm text-text-secondary">
            Add one here or sync from the Android app after sign-in.
          </p>
        </div>
      ) : (
        <ul className="space-y-2">
          {rows.map((r) => {
            const emails = asStringList(r.emails);
            return (
              <li
                key={r.id}
                className="flex items-start justify-between gap-3 rounded-xl border border-border bg-surface px-4 py-3"
              >
                <div>
                  <p className="font-semibold">{r.contact_person || "Client"}</p>
                  <p className="text-sm text-text-secondary">
                    {[r.company, emails[0]].filter(Boolean).join(" · ") || "No email"}
                  </p>
                </div>
                <button
                  type="button"
                  disabled={busy}
                  onClick={() => onDelete(r.id)}
                  className="text-xs font-semibold text-error"
                >
                  Delete
                </button>
              </li>
            );
          })}
        </ul>
      )}
    </div>
  );
}

export function ProjectsCrmPanel({
  initial,
  customers,
  canCreate,
  gateReason,
  upgradeHref,
}: {
  initial: CrmProject[];
  customers: CrmCustomer[];
  canCreate: boolean;
  gateReason?: string;
  upgradeHref?: string;
}) {
  const router = useRouter();
  const [rows, setRows] = useState(initial);
  const [name, setName] = useState("");
  const [customerId, setCustomerId] = useState(customers[0]?.id ?? "");
  const [budget, setBudget] = useState("");
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function onCreate(e: FormEvent) {
    e.preventDefault();
    if (!canCreate) return;
    setBusy(true);
    setError(null);
    try {
      const id = await upsertProjectClient({
        name,
        customer_id: customerId || null,
        budget: Number(budget) || 0,
      });
      setRows((prev) => [
        {
          id,
          owner_uid: "",
          local_id: null,
          customer_id: customerId || null,
          name: name.trim(),
          description: "",
          budget: Number(budget) || 0,
          currency: "USD",
          status: "not_started",
          priority: "medium",
          deadline: null,
          updated_at: new Date().toISOString(),
        },
        ...prev,
      ]);
      setName("");
      setBudget("");
      router.refresh();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Could not save project");
    } finally {
      setBusy(false);
    }
  }

  async function onDelete(id: string) {
    if (!confirm("Delete this project from cloud CRM?")) return;
    setBusy(true);
    try {
      await deleteCrmRow("crm_projects", id);
      setRows((prev) => prev.filter((r) => r.id !== id));
      router.refresh();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Delete failed");
    } finally {
      setBusy(false);
    }
  }

  const customerName = (id: string | null) =>
    customers.find((c) => c.id === id)?.contact_person || "Unassigned";

  return (
    <div className="space-y-4">
      <form onSubmit={onCreate} className="rounded-2xl border border-border bg-surface p-4 space-y-3">
        <p className="text-sm font-semibold text-navy">Add project (cloud)</p>
        {!canCreate && (
          <p className="rounded-lg bg-primary/10 px-3 py-2 text-sm text-navy">
            {gateReason}{" "}
            {upgradeHref && (
              <Link href={upgradeHref} className="font-semibold text-primary underline">
                Upgrade
              </Link>
            )}
          </p>
        )}
        <div className="grid gap-2 sm:grid-cols-3">
          <input
            required
            disabled={!canCreate || busy}
            placeholder="Project name"
            value={name}
            onChange={(e) => setName(e.target.value)}
            className="rounded-xl border border-border px-3 py-2 text-sm"
          />
          <select
            disabled={!canCreate || busy || customers.length === 0}
            value={customerId}
            onChange={(e) => setCustomerId(e.target.value)}
            className="rounded-xl border border-border px-3 py-2 text-sm"
          >
            {customers.length === 0 ? (
              <option value="">Add a client first</option>
            ) : (
              customers.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.contact_person}
                </option>
              ))
            )}
          </select>
          <input
            disabled={!canCreate || busy}
            placeholder="Budget"
            value={budget}
            onChange={(e) => setBudget(e.target.value)}
            className="rounded-xl border border-border px-3 py-2 text-sm"
          />
        </div>
        {error && <p className="text-sm text-error">{error}</p>}
        <button
          type="submit"
          disabled={!canCreate || busy || customers.length === 0}
          className="rounded-full bg-navy px-4 py-2 text-sm font-semibold text-white disabled:opacity-50"
        >
          {busy ? "Saving…" : "Save project"}
        </button>
      </form>

      {rows.length === 0 ? (
        <div className="rounded-2xl border border-dashed border-border bg-surface p-8 text-center">
          <p className="font-semibold">No cloud projects yet</p>
        </div>
      ) : (
        <ul className="space-y-2">
          {rows.map((r) => (
            <li
              key={r.id}
              className="flex items-start justify-between gap-3 rounded-xl border border-border bg-surface px-4 py-3"
            >
              <div>
                <p className="font-semibold">{r.name}</p>
                <p className="text-sm text-text-secondary">
                  {customerName(r.customer_id)} · {r.status}
                  {r.budget ? ` · ${r.currency} ${r.budget}` : ""}
                </p>
              </div>
              <button
                type="button"
                disabled={busy}
                onClick={() => onDelete(r.id)}
                className="text-xs font-semibold text-error"
              >
                Delete
              </button>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}

export function InvoicesCrmPanel({
  initial,
  customers,
  projects,
  canCreate,
  gateReason,
  upgradeHref,
}: {
  initial: CrmInvoice[];
  customers: CrmCustomer[];
  projects: CrmProject[];
  canCreate: boolean;
  gateReason?: string;
  upgradeHref?: string;
}) {
  const router = useRouter();
  const [rows, setRows] = useState(initial);
  const [number, setNumber] = useState(`INV-${Date.now().toString().slice(-6)}`);
  const [customerId, setCustomerId] = useState(customers[0]?.id ?? "");
  const [projectId, setProjectId] = useState("");
  const [total, setTotal] = useState("");
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function onCreate(e: FormEvent) {
    e.preventDefault();
    if (!canCreate) return;
    setBusy(true);
    setError(null);
    try {
      const id = await upsertInvoiceClient({
        invoice_number: number,
        customer_id: customerId || null,
        project_id: projectId || null,
        total: Number(total) || 0,
        status: "draft",
      });
      setRows((prev) => [
        {
          id,
          owner_uid: "",
          local_id: null,
          customer_id: customerId || null,
          project_id: projectId || null,
          invoice_number: number.trim(),
          status: "draft",
          total: Number(total) || 0,
          currency: "USD",
          line_items: [],
          due_date: null,
          updated_at: new Date().toISOString(),
        },
        ...prev,
      ]);
      setNumber(`INV-${Date.now().toString().slice(-6)}`);
      setTotal("");
      router.refresh();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Could not save invoice");
    } finally {
      setBusy(false);
    }
  }

  async function onDelete(id: string) {
    if (!confirm("Delete this invoice from cloud CRM?")) return;
    setBusy(true);
    try {
      await deleteCrmRow("crm_invoices", id);
      setRows((prev) => prev.filter((r) => r.id !== id));
      router.refresh();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Delete failed");
    } finally {
      setBusy(false);
    }
  }

  return (
    <div className="space-y-4">
      <form onSubmit={onCreate} className="rounded-2xl border border-border bg-surface p-4 space-y-3">
        <p className="text-sm font-semibold text-navy">Add invoice (cloud)</p>
        {!canCreate && (
          <p className="rounded-lg bg-primary/10 px-3 py-2 text-sm text-navy">
            {gateReason}{" "}
            {upgradeHref && (
              <Link href={upgradeHref} className="font-semibold text-primary underline">
                Upgrade
              </Link>
            )}
          </p>
        )}
        <div className="grid gap-2 sm:grid-cols-2 lg:grid-cols-4">
          <input
            required
            disabled={!canCreate || busy}
            placeholder="Invoice #"
            value={number}
            onChange={(e) => setNumber(e.target.value)}
            className="rounded-xl border border-border px-3 py-2 text-sm"
          />
          <select
            disabled={!canCreate || busy || customers.length === 0}
            value={customerId}
            onChange={(e) => setCustomerId(e.target.value)}
            className="rounded-xl border border-border px-3 py-2 text-sm"
          >
            {customers.length === 0 ? (
              <option value="">Add a client first</option>
            ) : (
              customers.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.contact_person}
                </option>
              ))
            )}
          </select>
          <select
            disabled={!canCreate || busy}
            value={projectId}
            onChange={(e) => setProjectId(e.target.value)}
            className="rounded-xl border border-border px-3 py-2 text-sm"
          >
            <option value="">No project</option>
            {projects.map((p) => (
              <option key={p.id} value={p.id}>
                {p.name}
              </option>
            ))}
          </select>
          <input
            disabled={!canCreate || busy}
            placeholder="Total"
            value={total}
            onChange={(e) => setTotal(e.target.value)}
            className="rounded-xl border border-border px-3 py-2 text-sm"
          />
        </div>
        {error && <p className="text-sm text-error">{error}</p>}
        <button
          type="submit"
          disabled={!canCreate || busy || customers.length === 0}
          className="rounded-full bg-navy px-4 py-2 text-sm font-semibold text-white disabled:opacity-50"
        >
          {busy ? "Saving…" : "Save invoice"}
        </button>
      </form>

      {rows.length === 0 ? (
        <div className="rounded-2xl border border-dashed border-border bg-surface p-8 text-center">
          <p className="font-semibold">No cloud invoices yet</p>
        </div>
      ) : (
        <ul className="space-y-2">
          {rows.map((r) => (
            <li
              key={r.id}
              className="flex items-center justify-between rounded-xl border border-border bg-surface px-4 py-3"
            >
              <div>
                <p className="font-semibold">{r.invoice_number}</p>
                <p className="text-sm text-text-secondary">{r.status}</p>
              </div>
              <div className="flex items-center gap-3">
                <p className="font-bold">
                  {r.currency} {Number(r.total ?? 0).toFixed(2)}
                </p>
                <button
                  type="button"
                  disabled={busy}
                  onClick={() => onDelete(r.id)}
                  className="text-xs font-semibold text-error"
                >
                  Delete
                </button>
              </div>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
