"use client";

import { useEffect, useState } from "react";
import { Save, Shield } from "lucide-react";
import { useAdminData } from "@/components/admin/AdminDataProvider";
import {
  AdminPageHeader,
  AdminBtn,
  FilterBar,
  PageLayout,
  SidePanel,
  SideCard,
  StatusPill,
  ErrorBanner,
} from "@/components/admin/ui";

const STORAGE_KEY = "clivora.admin.settings.draft";

type Draft = {
  siteName: string;
  supportEmail: string;
  commission: string;
  registrationOpen: boolean;
  freelancerSignup: boolean;
  fromName: string;
  fromAddress: string;
};

const DEFAULTS: Draft = {
  siteName: "CLIVORA",
  supportEmail: "support@clivora.com",
  commission: "0",
  registrationOpen: true,
  freelancerSignup: true,
  fromName: "CLIVORA",
  fromAddress: "noreply@clivora.com",
};

export default function AdminSettingsPage() {
  const { data, loading } = useAdminData();
  const [activeTab, setActiveTab] = useState("general");
  const [q, setQ] = useState("");
  const [draft, setDraft] = useState<Draft>(DEFAULTS);
  const [savedAt, setSavedAt] = useState<string | null>(null);
  const flags = data?.flags ?? [];

  useEffect(() => {
    try {
      const raw = localStorage.getItem(STORAGE_KEY);
      if (raw) setDraft({ ...DEFAULTS, ...JSON.parse(raw) });
    } catch {
      /* ignore */
    }
  }, []);

  function save() {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(draft));
    setSavedAt(new Date().toLocaleString());
  }

  const tabMatch = (label: string) => {
    const needle = q.trim().toLowerCase();
    if (!needle) return true;
    return label.toLowerCase().includes(needle);
  };

  return (
    <div>
      {data?.warning && (
        <ErrorBanner
          message={data.warning}
          onViewLogs={() => {
            window.location.href = "/admin/events";
          }}
        />
      )}

      <AdminPageHeader
        title="System Settings"
        subtitle="Local draft settings for this browser. Server-side config APIs ship next."
        actions={
          <AdminBtn variant="primary" onClick={save}>
            <Save className="h-3.5 w-3.5" /> Save changes
          </AdminBtn>
        }
      />

      <PageLayout
        main={
          <div>
            <FilterBar
              searchPlaceholder="Search settings…"
              searchValue={q}
              onSearchChange={setQ}
              tabs={[
                { id: "general", label: "General" },
                { id: "platform", label: "Platform" },
                { id: "email", label: "Email" },
              ]}
              activeTab={activeTab}
              onTabChange={setActiveTab}
              onReset={() => {
                setActiveTab("general");
                setQ("");
              }}
            />

            {!data && loading ? (
              <div className="rounded-2xl border border-slate-200 bg-white p-10 text-center text-sm text-slate-500">
                Loading settings…
              </div>
            ) : (
              <div className="space-y-4">
                {savedAt && (
                  <p className="rounded-xl border border-emerald-200 bg-emerald-50 px-3 py-2 text-sm text-emerald-800">
                    Draft saved on this device at {savedAt}.
                  </p>
                )}

                {activeTab === "general" && tabMatch("general site name support") && (
                  <section className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
                    <h3 className="mb-4 text-sm font-bold text-slate-900">Site information</h3>
                    <div className="grid gap-4 sm:grid-cols-2">
                      <Field label="Site name">
                        <input
                          value={draft.siteName}
                          onChange={(e) => setDraft((d) => ({ ...d, siteName: e.target.value }))}
                          className="w-full rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm outline-none focus:border-teal-400"
                        />
                      </Field>
                      <Field label="Support email">
                        <input
                          value={draft.supportEmail}
                          onChange={(e) => setDraft((d) => ({ ...d, supportEmail: e.target.value }))}
                          className="w-full rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm outline-none focus:border-teal-400"
                        />
                      </Field>
                    </div>
                    <div className="mt-4 flex justify-end">
                      <AdminBtn variant="primary" onClick={save}>
                        <Save className="h-3.5 w-3.5" /> Save general
                      </AdminBtn>
                    </div>
                  </section>
                )}

                {activeTab === "platform" && tabMatch("platform commission registration freelancer") && (
                  <section className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
                    <h3 className="mb-4 text-sm font-bold text-slate-900">Platform</h3>
                    <p className="mb-3 text-xs text-slate-500">
                      CLIVORA markets $0 platform fee. Commission field is a draft note only.
                    </p>
                    <div className="grid gap-4 sm:grid-cols-2">
                      <Field label="Commission rate (%)">
                        <input
                          value={draft.commission}
                          onChange={(e) => setDraft((d) => ({ ...d, commission: e.target.value }))}
                          className="w-full rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm outline-none focus:border-teal-400"
                        />
                      </Field>
                      <div className="space-y-3 sm:col-span-2">
                        <Toggle
                          label="Open registration"
                          checked={draft.registrationOpen}
                          onChange={(v) => setDraft((d) => ({ ...d, registrationOpen: v }))}
                        />
                        <Toggle
                          label="Allow freelancer signup"
                          checked={draft.freelancerSignup}
                          onChange={(v) => setDraft((d) => ({ ...d, freelancerSignup: v }))}
                        />
                      </div>
                    </div>
                    <div className="mt-4 flex justify-end">
                      <AdminBtn variant="primary" onClick={save}>
                        <Save className="h-3.5 w-3.5" /> Save platform
                      </AdminBtn>
                    </div>
                  </section>
                )}

                {activeTab === "email" && tabMatch("email from name address") && (
                  <section className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
                    <h3 className="mb-4 text-sm font-bold text-slate-900">Email</h3>
                    <div className="grid gap-4 sm:grid-cols-2">
                      <Field label="From name">
                        <input
                          value={draft.fromName}
                          onChange={(e) => setDraft((d) => ({ ...d, fromName: e.target.value }))}
                          className="w-full rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm outline-none focus:border-teal-400"
                        />
                      </Field>
                      <Field label="From address">
                        <input
                          value={draft.fromAddress}
                          onChange={(e) => setDraft((d) => ({ ...d, fromAddress: e.target.value }))}
                          className="w-full rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm outline-none focus:border-teal-400"
                        />
                      </Field>
                    </div>
                    <div className="mt-4 flex justify-end">
                      <AdminBtn variant="primary" onClick={save}>
                        <Save className="h-3.5 w-3.5" /> Save email
                      </AdminBtn>
                    </div>
                  </section>
                )}

                <section className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
                  <h3 className="mb-3 text-sm font-bold text-slate-900">Feature flags</h3>
                  {flags.length === 0 ? (
                    <p className="text-sm text-slate-500">No feature flags loaded.</p>
                  ) : (
                    <ul className="divide-y divide-slate-100">
                      {flags
                        .filter((f) => tabMatch(String(f.key ?? "") + String(f.description ?? "")))
                        .map((f) => (
                          <li
                            key={String(f.id ?? f.key)}
                            className="flex items-center justify-between gap-3 py-2.5 text-sm"
                          >
                            <div className="min-w-0">
                              <div className="font-bold text-slate-800">{String(f.key)}</div>
                              <div className="truncate text-xs text-slate-500">
                                {String(f.description || "")}
                              </div>
                            </div>
                            <StatusPill status={f.value ? "active" : "inactive"} />
                          </li>
                        ))}
                    </ul>
                  )}
                </section>
              </div>
            )}
          </div>
        }
        side={
          <SidePanel>
            <SideCard title="System Overview">
              <div className="space-y-3 text-sm">
                <div className="flex items-center gap-2">
                  <Shield className="h-4 w-4 text-teal-600" />
                  <span className="font-bold text-slate-800">CLIVORA web</span>
                </div>
                <p className="text-xs leading-relaxed text-slate-500">
                  Settings above save as a browser draft. Backups and remote config require a later
                  admin API — fake backup buttons were removed.
                </p>
              </div>
            </SideCard>
          </SidePanel>
        }
      />
    </div>
  );
}

function Field({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <label className="block text-sm">
      <span className="mb-1.5 block text-xs font-semibold text-slate-500">{label}</span>
      {children}
    </label>
  );
}

function Toggle({
  label,
  checked,
  onChange,
}: {
  label: string;
  checked: boolean;
  onChange: (v: boolean) => void;
}) {
  return (
    <button
      type="button"
      onClick={() => onChange(!checked)}
      className="flex w-full items-center justify-between rounded-xl border border-slate-200 bg-slate-50 px-3 py-2.5 text-sm font-semibold text-slate-700"
    >
      {label}
      <span
        className={`relative h-5 w-9 rounded-full transition ${checked ? "bg-teal-600" : "bg-slate-300"}`}
      >
        <span
          className={`absolute top-0.5 h-4 w-4 rounded-full bg-white transition ${checked ? "left-4" : "left-0.5"}`}
        />
      </span>
    </button>
  );
}
