"use client";

import { useState } from "react";
import { uintCV, cvToHex } from "@stacks/transactions";
import {
  APP_DETAILS,
  CONTRACT_ADDRESS,
  CORE_CONTRACT,
  assertContractAddress,
} from "../lib/stacks";

type TxStatus = {
  label: string;
  txId?: string;
  error?: string;
};

const teams = [
  { id: 1, name: "Brazil" },
  { id: 2, name: "Argentina" },
  { id: 3, name: "France" },
  { id: 4, name: "England" },
  { id: 5, name: "Japan" },
  { id: 6, name: "Portugal" },
  { id: 7, name: "Spain" },
  { id: 8, name: "Germany" },
];

export default function FanCupApp() {
  const [status, setStatus] = useState<TxStatus>({ label: "Ready" });

  const [teamId, setTeamId] = useState(1);
  const [matchId, setMatchId] = useState(1);
  const [winnerPick, setWinnerPick] = useState(1);
  const [scoreA, setScoreA] = useState(2);
  const [scoreB, setScoreB] = useState(1);
  const [boostAmount, setBoostAmount] = useState(1);

  async function connectWallet() {
    try {
      const stacksConnect = await import("@stacks/connect");

      const connectFn = (stacksConnect as any).connect;

      if (!connectFn) {
        throw new Error("connect() not found in @stacks/connect");
      }

      await connectFn({
        appDetails: APP_DETAILS,
      });

      setStatus({ label: "Wallet connected" });
    } catch (err) {
      setStatus({
        label: "Wallet error",
        error: err instanceof Error ? err.message : String(err),
      });
    }
  }

  async function callCore(functionName: string, functionArgs: any[] = []) {
    try {
      assertContractAddress();

      const stacksConnect = await import("@stacks/connect");
      const request = (stacksConnect as any).request;

      if (!request) {
        throw new Error("request() not found in @stacks/connect");
      }

      setStatus({
        label: `Waiting wallet confirmation: ${functionName}`,
      });

      const result = await request("stx_callContract", {
        contract: `${CONTRACT_ADDRESS}.${CORE_CONTRACT}`,
        functionName,
        functionArgs: functionArgs.map((arg) => cvToHex(arg)),
        network: "mainnet",
      });

      setStatus({
        label: `${functionName} submitted`,
        txId: result?.txid || result?.txId || result?.transaction_id,
      });
    } catch (err) {
      setStatus({
        label: "TX error",
        error: err instanceof Error ? err.message : String(err),
      });
    }
  }

  return (
    <main className="min-h-screen bg-black text-white">
      <section className="mx-auto max-w-6xl px-5 py-10">
        <nav className="mb-10 flex items-center justify-between gap-4">
          <div>
            <p className="text-xs font-semibold uppercase tracking-[0.3em] text-orange-400">
              Built on Stacks
            </p>
            <h1 className="mt-2 text-3xl font-black tracking-tight md:text-5xl">
              FanCup Stacks 2026
            </h1>
          </div>

          <button
            onClick={connectWallet}
            className="rounded-xl bg-orange-500 px-4 py-3 text-sm font-bold text-black hover:bg-orange-400"
          >
            Connect Wallet
          </button>
        </nav>

        <div className="mb-8 rounded-2xl border border-white/10 bg-white/5 p-5">
          <p className="text-sm text-gray-400">Contract</p>
          <p className="mt-1 break-all font-mono text-sm">
            {CONTRACT_ADDRESS
              ? `${CONTRACT_ADDRESS}.${CORE_CONTRACT}`
              : "Contract address not set yet"}
          </p>

          <div className="mt-4 rounded-xl bg-black/50 p-4">
            <p className="text-sm font-semibold text-orange-300">
              Status: {status.label}
            </p>

            {status.txId && (
              <p className="mt-2 break-all font-mono text-xs text-green-400">
                TX: {status.txId}
              </p>
            )}

            {status.error && (
              <p className="mt-2 break-all font-mono text-xs text-red-400">
                {status.error}
              </p>
            )}
          </div>
        </div>

        <div className="grid gap-5 md:grid-cols-3">
          <ActionCard
            title="Join Tournament"
            description="Create your onchain FanCup profile."
            button="Join"
            onClick={() => callCore("join-tournament")}
          />

          <div className="rounded-2xl border border-white/10 bg-white/5 p-5">
            <h2 className="text-lg font-bold">Choose Team</h2>
            <p className="mt-2 text-sm text-gray-400">
              Select your favorite national team.
            </p>

            <select
              value={teamId}
              onChange={(e: any) => setTeamId(Number(e.currentTarget.value))}
              className="mt-4 w-full rounded-xl border border-white/10 bg-black p-3 text-white"
            >
              {teams.map((team) => (
                <option key={team.id} value={team.id}>
                  {team.id}. {team.name}
                </option>
              ))}
            </select>

            <button
              onClick={() => callCore("choose-team", [uintCV(teamId)])}
              className="mt-4 w-full rounded-xl bg-white px-4 py-3 font-bold text-black hover:bg-gray-200"
            >
              Choose Team
            </button>
          </div>

          <ActionCard
            title="Daily Check-in"
            description="Build your supporter streak and earn fan points."
            button="Check In"
            onClick={() => callCore("daily-checkin")}
          />

          <div className="rounded-2xl border border-white/10 bg-white/5 p-5">
            <h2 className="text-lg font-bold">Predict Winner</h2>
            <p className="mt-2 text-sm text-gray-400">
              Pick match result: draw, team A, or team B.
            </p>

            <label className="mt-4 block text-sm text-gray-400">Match ID</label>
            <input
              value={matchId}
              onChange={(e: any) => setMatchId(Number(e.currentTarget.value))}
              type="number"
              min="1"
              className="mt-2 w-full rounded-xl border border-white/10 bg-black p-3"
            />

            <label className="mt-4 block text-sm text-gray-400">
              Winner Pick
            </label>
            <select
              value={winnerPick}
              onChange={(e: any) =>
                setWinnerPick(Number(e.currentTarget.value))
              }
              className="mt-2 w-full rounded-xl border border-white/10 bg-black p-3"
            >
              <option value={0}>Draw</option>
              <option value={1}>Team A Win</option>
              <option value={2}>Team B Win</option>
            </select>

            <button
              onClick={() =>
                callCore("predict-winner", [
                  uintCV(matchId),
                  uintCV(winnerPick),
                ])
              }
              className="mt-4 w-full rounded-xl bg-white px-4 py-3 font-bold text-black hover:bg-gray-200"
            >
              Predict Winner
            </button>
          </div>

          <div className="rounded-2xl border border-white/10 bg-white/5 p-5">
            <h2 className="text-lg font-bold">Predict Score</h2>
            <p className="mt-2 text-sm text-gray-400">
              Submit exact score prediction.
            </p>

            <label className="mt-4 block text-sm text-gray-400">Score A</label>
            <input
              value={scoreA}
              onChange={(e: any) => setScoreA(Number(e.currentTarget.value))}
              type="number"
              min="0"
              max="20"
              className="mt-2 w-full rounded-xl border border-white/10 bg-black p-3"
            />

            <label className="mt-4 block text-sm text-gray-400">Score B</label>
            <input
              value={scoreB}
              onChange={(e: any) => setScoreB(Number(e.currentTarget.value))}
              type="number"
              min="0"
              max="20"
              className="mt-2 w-full rounded-xl border border-white/10 bg-black p-3"
            />

            <button
              onClick={() =>
                callCore("predict-score", [
                  uintCV(matchId),
                  uintCV(scoreA),
                  uintCV(scoreB),
                ])
              }
              className="mt-4 w-full rounded-xl bg-white px-4 py-3 font-bold text-black hover:bg-gray-200"
            >
              Predict Score
            </button>
          </div>

          <ActionCard
            title="Claim Winner Points"
            description="Claim points after match result is finalized."
            button="Claim Points"
            onClick={() => callCore("claim-points", [uintCV(matchId)])}
          />

          <ActionCard
            title="Claim Score Points"
            description="Claim bonus points for exact score prediction."
            button="Claim Score"
            onClick={() => callCore("claim-score-points", [uintCV(matchId)])}
          />

          <div className="rounded-2xl border border-white/10 bg-white/5 p-5">
            <h2 className="text-lg font-bold">Boost Team</h2>
            <p className="mt-2 text-sm text-gray-400">
              Spend fan points to boost your favorite team.
            </p>

            <label className="mt-4 block text-sm text-gray-400">
              Boost Amount
            </label>
            <input
              value={boostAmount}
              onChange={(e: any) =>
                setBoostAmount(Number(e.currentTarget.value))
              }
              type="number"
              min="1"
              className="mt-2 w-full rounded-xl border border-white/10 bg-black p-3"
            />

            <button
              onClick={() =>
                callCore("boost-team", [uintCV(teamId), uintCV(boostAmount)])
              }
              className="mt-4 w-full rounded-xl bg-white px-4 py-3 font-bold text-black hover:bg-gray-200"
            >
              Boost Team
            </button>
          </div>
        </div>
      </section>
    </main>
  );
}

function ActionCard({
  title,
  description,
  button,
  onClick,
}: {
  title: string;
  description: string;
  button: string;
  onClick: () => void;
}) {
  return (
    <div className="rounded-2xl border border-white/10 bg-white/5 p-5">
      <h2 className="text-lg font-bold">{title}</h2>
      <p className="mt-2 text-sm text-gray-400">{description}</p>
      <button
        onClick={onClick}
        className="mt-4 w-full rounded-xl bg-white px-4 py-3 font-bold text-black hover:bg-gray-200"
      >
        {button}
      </button>
    </div>
  );
}
