import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "FanCup Stacks 2026",
  description: "Onchain football prediction and fan voting arena on Stacks.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
