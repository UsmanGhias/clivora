import { getAdminEmails } from "@/lib/admin";
import AdminDashboard from "./admin-dashboard";

export default function AdminPage() {
  const adminEmails = getAdminEmails();

  return <AdminDashboard adminEmails={adminEmails} />;
}
