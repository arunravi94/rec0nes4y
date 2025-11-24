#!/bin/bash

echo "====================================================="
echo "   Installing Dependencies for rec0nes4y"
echo "====================================================="

# ---------- Update System ----------
echo "[+] Updating package list..."
sudo apt update -y

# ---------- Install Base Packages ----------
echo "[+] Installing required system tools..."
sudo apt install -y \
    curl wget git python3 python3-pip build-essential \
    nmap whatweb gobuster dirsearch whois unzip jq

# ---------- Check / Install Golang ----------
if ! command -v go &> /dev/null; then
    echo "[!] Golang not found — installing Go"
    sudo apt install golang -y
else
    echo "[+] Golang is already installed"
fi

export PATH=$PATH:$HOME/go/bin

# ---------- Install Go-based Tools ----------
echo "[+] Installing Go security tools..."

go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install github.com/OWASP/Amass/v3/...@latest
go install github.com/tomnomnom/assetfinder@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/lc/gau@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/guelfoweb/hele@latest

# ---------- Move Go binaries to path ----------
echo "[+] Exporting Go binaries to PATH"
echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
source ~/.bashrc

# ---------- Check installations ----------
echo
echo "====================================================="
echo "   Checking installed tools"
echo "====================================================="

TOOLS=("subfinder" "assetfinder" "amass" "dnsx" "httpx" "naabu" "nuclei" "katana" "waybackurls" "gau" "gobuster" "whatweb" "hele" "nmap" "whois")
for t in "${TOOLS[@]}"; do
    if command -v $t &>/dev/null; then
        echo "[✓] $t installed"
    else
        echo "[✗] $t NOT installed"
    fi
done

# ---------- Final message ----------
echo
echo "====================================================="
echo "  rec0nes4y installation complete!"
echo "====================================================="
echo
echo "[+] Run the tool using:"
echo "    ./rec0nes4y.sh <domain>"
echo
exit 0
