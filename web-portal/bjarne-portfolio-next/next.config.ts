import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  async redirects() {
    return [
      {
        source: '/de/impressum',
        destination: '/de/legal-notice',
        permanent: true,
      },
      {
        source: '/en/impressum',
        destination: '/en/legal-notice',
        permanent: true,
      },
      {
        source: '/de/datenschutz',
        destination: '/de/privacy-policy',
        permanent: true,
      },
      {
        source: '/en/datenschutz',
        destination: '/en/privacy-policy',
        permanent: true,
      },
    ];
  },
};

export default nextConfig;
