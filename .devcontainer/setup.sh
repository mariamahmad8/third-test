#!/usr/bin/env bash
set -euo pipefail

echo "==> Setting up helper commands and language env..."

# Make sure basic tools are present (common-utils feature covers most of these)
sudo apt-get update -y
sudo apt-get install -y curl ca-certificates git

# Add a convenience wrapper for the GoodMem interactive installer
sudo tee /usr/local/bin/gm-install >/dev/null <<'EOF'
#!/usr/bin/env bash
set -e
# Runs the official interactive installer. Expect prompts.
curl -s https://get.goodmem.ai | bash
EOF
sudo chmod +x /usr/local/bin/gm-install

# Optional: place to pin SDK installs if/when you have package names.
# (Left blank to avoid breaking on unknown package names.)

echo
echo "==> GoodMem modes"
echo "   - GOODMEM_MODE=external (default): connect to an existing GoodMem server"
echo "   - GOODMEM_MODE=local:    run GoodMem locally in this container (Docker-in-Docker)"
echo
echo "==> To run the interactive installer manually when you're ready:"
echo "       gm-install"
echo
echo "NOTE: The installer is interactive by design. We don't auto-run it during build."
echo "      If you really want to force it during creation, rebuild with:"
echo "         GOODMEM_AUTO_INSTALL=1 GOODMEM_MODE=local"
echo

if [[ "${GOODMEM_MODE:-external}" == "local" && "${GOODMEM_AUTO_INSTALL:-0}" == "1" ]]; then
  echo "GOODMEM_MODE=local and GOODMEM_AUTO_INSTALL=1 -> running installer now..."
  gm-install || echo "Installer exited (likely due to prompts). Run 'gm-install' in a terminal."
fi

echo "Setup complete."
