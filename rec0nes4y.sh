#!/bin/bash

TARGET=$1

# --- HELP FEATURE ---
if [[ "$TARGET" == "-h" || "$TARGET" == "--help" || -z "$TARGET" ]]; then
    echo "======================="
    echo " rec0nes4y - Ultimate Recon Tool"
    echo "======================="
    echo "Usage:   ./rec0nes4y.sh <domain>"
    echo "Example: ./rec0nes4y.sh example.com"
    echo
    echo "Modules Included:"
    echo "  • WHOIS Info"
    echo "  • Subdomain Enumeration (subfinder, assetfinder)"
    echo "  • Alive Checking (httpx)"
    echo "  • Port & Service Scan (nmap)"
    echo "  • Technology Fingerprinting (whatweb)"
    echo "  • Directory Bruteforce (gobuster)"
    echo "  • JS + Endpoint Extraction (HeLe)"
    echo "  • Vulnerability Scan (nuclei)"
    echo
    echo "Output:"
    echo "  → All results saved in: rec0nes4y-<domain>/"
    echo
    echo "Example Workflow:"
    echo "  ./rec0nes4y.sh target.com"
    echo "  cd rec0nes4y-target.com"
    echo "  cat nmap.txt nuclei.txt hele_links.txt"
    echo
    exit 0
fi
# ---------------------

OUT="rec0nes4y-$TARGET"
mkdir -p "$OUT"
cd "$OUT"

echo "[+] Starting rec0nes4y on $TARGET..."

# WHOIS
echo "[+] WHOIS Info"
whois $TARGET > whois.txt

# Subdomain Enumeration
echo "[+] Enumerating subdomains..."
subfinder -silent -d $TARGET | tee subfinder.txt
assetfinder --subs-only $TARGET | tee assetfinder.txt
cat subfinder.txt assetfinder.txt | sort -u > subs_all.txt

# Alive Domains
echo "[+] Checking alive hosts..."
cat subs_all.txt | httpx -silent -status-code -title -tech-detect | tee alive.txt

# Nmap Scan
echo "[+] Running Nmap scan..."
nmap -Pn -sC -sV -T4 $TARGET -oN nmap.txt

# Technology Fingerprinting
echo "[+] Analyzing tech stack..."
whatweb $TARGET > whatweb.txt

# Directory bruteforce
echo "[+] Directory scan..."
gobuster dir -u https://$TARGET -w /usr/share/wordlists/dirb/common.txt -o gobuster.txt

# HeLe (JS + Endpoint Hunter)
echo "[+] Running HeLe endpoint extraction..."
echo "URL: https://$TARGET" | hele -crawl -deep > hele_raw.txt
cat hele_raw.txt | grep -Eo '(http|https)://[^ ]+' | sort -u > hele_links.txt

# Nuclei Scan
echo "[+] Running Nuclei vulnerabilities scan..."
nuclei -u https://$TARGET -o nuclei.txt

echo "----------------------------------------"
echo "[+] Recon completed!"
echo "[+] Results saved in: $OUT"
echo "----------------------------------------"
