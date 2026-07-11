import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  reactStrictMode: true,
  eslint: {
    ignoreDuringBuilds: true,
  },
  async redirects() {
    return [
      {
        source: "/docs/ai-research-brief",
        destination: "/docs",
        permanent: true,
      },
      {
        source: "/docs/CLIVORA-AI-Research-Brief.pdf",
        destination: "/docs",
        permanent: true,
      },
      {
        source: "/docs/architecture",
        destination: "/docs",
        permanent: true,
      },
    ];
  },
  async headers() {
    return [
      {
        source: "/docs/ai-research-brief",
        headers: [{ key: "X-Robots-Tag", value: "noindex, nofollow" }],
      },
    ];
  },
};

export default nextConfig;
