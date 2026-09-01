#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

echo "== Hermes Android full setup =="

pkg update -y
pkg install -y curl git gh python clang rust make pkg-config libffi openssl nodejs ripgrep ffmpeg

echo "== Installing Hermes Agent from official Nous Research installer =="
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

echo "== Verifying Hermes base install =="
hermes --version
hermes doctor || true

echo "== Ensuring bundled skills are available =="
hermes skills opt-in --sync || true

echo "== Configuring Magnific remote MCP =="
if ! hermes mcp test magnific >/dev/null 2>&1; then
  hermes mcp add --url https://mcp.magnific.com --auth oauth magnific || true
fi

echo
echo "== ChatGPT / OpenAI authorization =="
echo "In the menu that opens, choose: ChatGPT or Codex Subscription"
echo "Then approve the device/browser login."
hermes model

echo
echo "== GitHub authorization =="
if gh auth status >/dev/null 2>&1; then
  echo "GitHub is already authenticated."
else
  gh auth login --hostname github.com --git-protocol https --web
fi

echo
echo "== Magnific authorization =="
echo "Approve Magnific in the browser when asked."
echo "If the Android callback page fails to load, copy the final redirect URL and paste it back here."
hermes mcp login magnific

echo
echo "== Final verification =="
hermes --version
hermes doctor
gh auth status
hermes mcp test magnific

echo
echo "ALL AUTOMATABLE STEPS FINISHED."
echo "If every verification above passed, start Hermes with: hermes"
