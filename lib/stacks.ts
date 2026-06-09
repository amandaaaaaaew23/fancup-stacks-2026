export const APP_DETAILS = {
  name: "FanCup Stacks 2026",
  icon: "/logo.png",
};

export const CONTRACT_ADDRESS =
  process.env.NEXT_PUBLIC_CONTRACT_ADDRESS || "";

export const CORE_CONTRACT =
  process.env.NEXT_PUBLIC_CORE_CONTRACT || "fancup-core";

export const BADGE_CONTRACT =
  process.env.NEXT_PUBLIC_BADGE_CONTRACT || "fancup-badge";

export function assertContractAddress() {
  if (!CONTRACT_ADDRESS) {
    throw new Error(
      "NEXT_PUBLIC_CONTRACT_ADDRESS is empty. Add your deployed Stacks contract address in .env.local"
    );
  }
}
