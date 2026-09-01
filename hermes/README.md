# Hermes Agent integration for Android / Termux

This directory contains a safe bootstrap for using Hermes Agent on Android with:

- ChatGPT / OpenAI Codex OAuth as the model provider
- GitHub via the `gh` CLI and Hermes' bundled GitHub skill
- Magnific via the official remote MCP endpoint and OAuth 2.1

No passwords, API keys, OAuth tokens, or other secrets belong in this repository.

## 1. Install on Android

Use Termux and run:

```bash
bash hermes/setup-termux.sh
```

The script installs the Android prerequisites, installs Hermes from the official Nous Research installer, restores bundled skills, and adds the Magnific MCP server definition.

## 2. Authorize ChatGPT / OpenAI

Run:

```bash
hermes model
```

Choose:

```text
ChatGPT or Codex Subscription
```

Complete the device/browser OAuth flow with the ChatGPT account you want Hermes to use.

## 3. Authorize GitHub

Run:

```bash
gh auth login
```

Choose GitHub.com, HTTPS, then browser/device-code login. Afterward verify:

```bash
gh auth status
```

Hermes ships with a bundled GitHub skill; the setup script re-seeds bundled skills so that capability is available.

## 4. Authorize Magnific

The server is configured as:

```yaml
mcp_servers:
  magnific:
    url: "https://mcp.magnific.com"
    auth: oauth
```

Complete OAuth with:

```bash
hermes mcp login magnific
```

If Android cannot receive the loopback callback automatically, copy the final redirect URL from the browser and paste it back into the Hermes prompt.

Then test:

```bash
hermes mcp test magnific
```

## 5. Verify

Run:

```bash
bash hermes/verify.sh
```

A clean installation should show Hermes installed, `hermes doctor` completing, GitHub authenticated, and the Magnific MCP test succeeding.

## Security

- Do not commit `~/.hermes/.env`.
- Do not commit `~/.hermes/mcp-tokens/`.
- Do not paste OAuth tokens, API keys, or GitHub tokens into Git.
- Magnific MCP actions consume plan credits.
