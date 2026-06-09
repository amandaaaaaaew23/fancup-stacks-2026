import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "FanCup Stacks 2026",
  description: "Onchain football prediction and fan voting arena on Stacks.",
  other: {
    "talentapp:project_verification":
      "4df6759d1ddaf1484446f3beb870ee6b2c939d9e1d68c0d95141c12b8d72b905183835a456292449a0490f140f3fc6ccf74e55382a0f20550fcadc2c51c78fee",
  },
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
