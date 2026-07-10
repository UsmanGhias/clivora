export type AccountType = "freelancer" | "client" | "admin";

export type Profile = {
  id: string;
  email: string | null;
  name: string | null;
  account_type: string | null;
  subscription_plan: string | null;
  role?: string | null;
};
