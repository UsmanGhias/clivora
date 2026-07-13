import { marketing } from "@/lib/marketing";

export function TrustLogos() {
  const t = marketing.trustBar;

  return (
    <section className="border-y border-slate-200/80 bg-white py-12">
      <div className="mx-auto max-w-7xl px-5 text-center lg:px-8">
        <p className="font-display text-lg font-bold text-navy sm:text-xl">{t.title}</p>
        <p className="mx-auto mt-2 max-w-2xl text-sm leading-relaxed text-slate-500">{t.body}</p>
        <div className="mt-8 grid grid-cols-2 gap-3 sm:grid-cols-4">
          {t.audiences.map((name) => (
            <div
              key={name}
              className="rounded-xl border border-slate-200 bg-[#F8FAFC] px-4 py-4 text-sm font-semibold text-navy"
            >
              {name}
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
