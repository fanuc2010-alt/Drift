#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

echo "== Hermes Android bootstrap =="

pkg update -y
pkg install -y curl git gh python clang rust make pkg-config libffi openssl nodejs ripgrep ffmpeg

echo "== Installing Hermes Agent from official Nous Research installer =="
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

echo "== Verifying Hermes =="
hermes --version
hermes doctor || true

echo "== Ensuring bundled skills are available =="
hermes skills opt-in --sync || true

echo "== Configuring Magnific remote MCP =="
if hermes mcp test magnific >/dev/null 2>&1; then
  echo "Magnific MCP already configured and reachable."
else
  hermes mcp add --url https://mcp.magnific.com --auth oauth magnific || true
fi

cat <<'EOF'

Bootstrap complete.

Two authorization steps require you, because OAuth consent cannot be delegated safely:

1) ChatGPT / OpenAI:
   hermes model
   Choose: ChatGPT or Codex Subscription

2) GitHub:
   gh auth login

3) Magnific:
   hermes mcp login magnific

Then run:
   bash hermes/verify.sh

EOF
