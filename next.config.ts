import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  test: /\.svg$/i,
  issuer: /\.[jt]sx?$/, // JS or TS ファイルからのインポートのみ対象
  use: ["@svgr/webpack"],
};

export default nextConfig;
