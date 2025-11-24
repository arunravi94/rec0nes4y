#!/bin/bash

echo "========================================="
echo "  rec0nes4y — Installation Started"
echo "========================================="

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "[!] Go is not installed. Installing Golang..."
    sudo apt update
    sudo apt install -y golang-go
fi

echo "[+] Updating packages..."
sudo apt update

echo "[+] Installing APT dependencies..."
sudo apt install -y nmap whatweb gobuster dirsearch whois build-essential git

echo "[+] Installing Go-based tools..."
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/OWASP/Amass/v3/...@latest
go install -v github.com/tomnomnom/assetfinder@latest
go install github.com/guelfoweb/hele@latest

echo "[+] Updating $PATH if needed..."
if [[ ":$PATH:" != *":$HOME/go/bin:"* ]]; then
    echo "export PATH=$PATH:$HOME/go/bin" >> ~/.bashrc
    export PATH=$PATH:$HOME/go/bin
fi

echo "[+] Making rec0nes4y.sh executable (if exists)..."
chmod +x rec0nes4y.sh 2>/dev/null

echo "========================================="
echo "   rec0nes4y Installation Completed"
echo "========================================="
echo
echo "[✓] Run the tool using:"
echo "    ./rec0nes4y.sh <domain>"
echo
