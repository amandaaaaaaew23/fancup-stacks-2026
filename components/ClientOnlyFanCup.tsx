"use client";

import dynamic from "next/dynamic";

const FanCupApp = dynamic(() => import("./FanCupApp"), {
  ssr: false,
});

export default function ClientOnlyFanCup() {
  return <FanCupApp />;
}
