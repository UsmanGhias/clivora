"use client";

import { useMemo, useState } from "react";
import { matchesAdminQuery } from "@/components/admin/ui";

/** Shared search state for admin list pages. */
export function useAdminSearch<T extends Record<string, unknown>>(rows: T[]) {
  const [q, setQ] = useState("");
  const filtered = useMemo(
    () => rows.filter((row) => matchesAdminQuery(row, q)),
    [rows, q],
  );
  return { q, setQ, filtered };
}
