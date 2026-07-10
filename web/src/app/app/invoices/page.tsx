import { createClient } from "@/lib/supabase/server";
import { getProfile, isClientAccount } from "@/lib/profile";

type InvoiceShareRow = {
  share_id: string;
  invoice_number?: string | null;
  total?: number | null;
  currency?: string | null;
  status?: string | null;
  client_email?: string | null;
  public_token?: string | null;
};

export default async function InvoicesPage() {
  const profile = await getProfile();
  const client = isClientAccount(profile);
  const supabase = await createClient();
  const uid = profile?.id ?? "";

  let rows: InvoiceShareRow[] = [];
  try {
    let q = supabase
      .from("invoice_shares")
      .select(
        "share_id, invoice_number, total, currency, status, client_email, freelancer_uid, client_uid, public_token, updated_at"
      )
      .order("updated_at", { ascending: false })
      .limit(40);
    q = client
      ? q.or(`client_uid.eq.${uid},client_email.eq.${profile?.email ?? ""}`)
      : q.eq("freelancer_uid", uid);
    const { data, error } = await q;
    if (!error && data) rows = data;
  } catch {
    rows = [];
  }

  return (
    <div className="space-y-4">
      <div>
        <h1 className="text-2xl font-extrabold">Invoices</h1>
        <p className="text-sm text-text-secondary">
          Cloud invoice shares from the same Supabase project as the mobile app.
        </p>
      </div>
      {rows.length === 0 ? (
        <div className="rounded-2xl border border-dashed border-border bg-surface p-8 text-center">
          <p className="font-semibold">No shared invoices yet</p>
          <p className="mt-2 text-sm text-text-secondary">
            Share an invoice from the app to see it here (and via public /i/ links).
          </p>
        </div>
      ) : (
        <ul className="space-y-2">
          {rows.map((r) => (
            <li
              key={r.share_id}
              className="flex items-center justify-between rounded-xl border border-border bg-surface px-4 py-3"
            >
              <div>
                <p className="font-semibold">{r.invoice_number}</p>
                <p className="text-sm text-text-secondary">
                  {client ? "From freelancer" : r.client_email} · {r.status}
                </p>
                {r.public_token && (
                  <a
                    href={`/i/${r.public_token}`}
                    className="text-xs font-semibold text-primary"
                  >
                    Public link →
                  </a>
                )}
              </div>
              <p className="font-bold">
                {r.currency} {Number(r.total ?? 0).toFixed(2)}
              </p>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
