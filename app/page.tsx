export default function Home() {
  return (
    <main className="min-h-screen bg-black text-white px-6 py-12">
      <section className="mx-auto max-w-4xl">
        <p className="mb-3 text-sm font-semibold text-orange-400">
          Built on Stacks
        </p>

        <h1 className="text-4xl font-bold tracking-tight">
          FanCup Stacks 2026
        </h1>

        <p className="mt-4 max-w-2xl text-gray-300">
          Onchain football prediction and fan voting arena powered by Stacks.
          Join the tournament, choose your team, predict matches, earn fan
          points, boost teams, and mint supporter badges.
        </p>

        <div className="mt-10 grid gap-4 md:grid-cols-3">
          <div className="rounded-2xl border border-white/10 bg-white/5 p-5">
            <h2 className="font-semibold">Predict Matches</h2>
            <p className="mt-2 text-sm text-gray-400">
              Submit winner and score predictions onchain.
            </p>
          </div>

          <div className="rounded-2xl border border-white/10 bg-white/5 p-5">
            <h2 className="font-semibold">Daily Check-in</h2>
            <p className="mt-2 text-sm text-gray-400">
              Build your supporter streak and earn fan points.
            </p>
          </div>

          <div className="rounded-2xl border border-white/10 bg-white/5 p-5">
            <h2 className="font-semibold">Fan Reputation</h2>
            <p className="mt-2 text-sm text-gray-400">
              Boost teams and collect onchain supporter badges.
            </p>
          </div>
        </div>
      </section>
    </main>
  );
}
