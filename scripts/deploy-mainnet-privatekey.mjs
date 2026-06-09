import dotenv from "dotenv";
import fs from "fs";
import {
  makeContractDeploy,
  broadcastTransaction,
  AnchorMode,
  ClarityVersion,
} from "@stacks/transactions";

dotenv.config({ path: ".env.local" });

const privateKey = process.env.STACKS_PRIVATE_KEY;
const stacksAddress = process.env.STACKS_ADDRESS;

if (!privateKey) {
  throw new Error("STACKS_PRIVATE_KEY missing in .env.local");
}

if (!stacksAddress) {
  throw new Error("STACKS_ADDRESS missing in .env.local");
}

const network = "mainnet";
const apiUrl = "https://api.mainnet.hiro.so";

/**
 * Core only.
 * Badge already deployed successfully.
 */
const contracts = [
  {
    name: "fancup-core",
    path: "contracts/fancup-core.clar",
  },
];

async function getNonce() {
  const res = await fetch(`${apiUrl}/extended/v1/address/${stacksAddress}/nonces`);

  if (!res.ok) {
    throw new Error(`Failed to fetch nonce: ${res.status} ${await res.text()}`);
  }

  const data = await res.json();

  console.log("Nonce data:");
  console.log(data);

  return Number(
    data.possible_next_nonce ??
      data.detected_missing_nonces?.[0] ??
      data.last_executed_tx_nonce + 1 ??
      0
  );
}

async function deployContract(contract, nonce) {
  const codeBody = fs.readFileSync(contract.path, "utf8");

  console.log(`\nDeploying ${contract.name}...`);
  console.log(`Deployer: ${stacksAddress}`);
  console.log(`Contract: ${stacksAddress}.${contract.name}`);
  console.log(`Nonce: ${nonce}`);
  console.log("Clarity version: Clarity 3");

  const tx = await makeContractDeploy({
    contractName: contract.name,
    codeBody,
    senderKey: privateKey,
    network,
    anchorMode: AnchorMode.Any,
    clarityVersion: ClarityVersion.Clarity3,
    fee: 100000,
    nonce,
  });

  const result = await broadcastTransaction(tx, network);

  console.log(`${contract.name} result:`);
  console.log(result);

  if (result?.error) {
    throw new Error(`${contract.name} deploy failed: ${JSON.stringify(result)}`);
  }

  return result.txid || result.txId || result;
}

async function main() {
  console.log("FanCup Stacks 2026 mainnet core deploy using private key");
  console.log(`Address: ${stacksAddress}`);

  let nonce = process.env.STACKS_NONCE
    ? Number(process.env.STACKS_NONCE)
    : await getNonce();

  for (const contract of contracts) {
    const txid = await deployContract(contract, nonce);
    console.log(`${contract.name} txid: ${txid}`);
    nonce += 1;
  }

  console.log("\nDone.");
  console.log("\nMainnet contracts:");
  console.log(`${stacksAddress}.fancup-core`);
  console.log(`${stacksAddress}.fancup-badge`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
