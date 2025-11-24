#!/bin/bash

#=======================================#
#   rec0nes4y - Automated Recon Script  #
#              Made by: Mayanz3r0       #
#=======================================#

# ---------- COLORS ----------
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[36m"
MAGENTA="\e[35m"
RESET="\e[0m"

# ---------- BANNER ----------
clear
echo -e "${MAGENTA}"
echo "██████╗ ███████╗ ██████╗  ██████╗ ███╗   ██╗███████╗███████╗ ██╗  ██╗"
echo "██╔══██╗██╔════╝██╔═══██╗██╔═══██╗████╗  ██║██╔════╝██╔════╝ ██║  ██║"
echo "██████╔╝█████╗  ██║   ██║██║   ██║██╔██╗ ██║█████╗  █████╗   ███████║"
echo "██╔══██╗██╔══╝  ██║   ██║██║   ██║██║╚██╗██║██╔══╝  ██╔══╝   ██╔══██║"
echo "██████╔╝███████╗╚██████╔╝╚██████╔╝██║ ╚████║███████╗██║      ██║  ██║"
echo "╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝      ╚═╝  ╚═╝"
echo -e "                     ${YELLOW}Recon For You — rec0nes4y${RESET}"
echo

# ---------- HELP MENU ----------
if [[ "$1" == "-h" || "$1" == "--help" || "$1" == "help" ]]; then
    echo -e "${YELLOW}================ rec0nes4y Help Menu ================${RESET}"
    echo -e "${BLUE}Usage:${RESET}"
    echo -e "  ./rec0nes4y.sh <domain> [--lite | --aggressive]"
    echo
    echo -e "${BLUE}Examples:${RESET}"
    echo -e "  ./rec0nes4y.sh example.com"
    echo -e "  ./rec0nes4y.sh example.com --lite"
    echo -e "  ./rec0nes4y.sh example.com --aggressive"
    echo -e
    echo -e "${BLUE}Scan Modes:${RESET}"
    echo -e "  --lite        Fast recon (subdomains + alive + fingerprint)"
    echo -e "  --aggressive  Full recon (all modules + vulnerability scan)"
    echo -e
    echo -e "${BLUE}Config File:${RESET}"
    echo -e "  You can edit scan behavior in: ${MAGENTA}config.ini${RESET}"
    echo -e "  Change wordlists, threads, nuclei severity/templates, etc."
    echo
    echo -e "${BLUE}Modules Included:${RESET}"
    echo -e "  WHOIS, Subfinder, Assetfinder, Amass"
    echo -e "  DNSX (optional), HTTPX, Naabu, Nmap"
    echo -e "  WhatWeb, Gobuster, HeLe, Katana"
    echo -e "  WaybackURLs / GAU, Nuclei"
    echo
    echo -e "${BLUE}Output:${RESET}"
    echo -e "  All findings saved inside folder:"
    echo -e "  ${GREEN}rec0nes4y-<domain>/${RESET}"
    echo
    echo -e "${YELLOW}=====================================================${RESET}"
    exit 0
fi


# ---------- CONFIG FILE ----------
CONFIG_FILE="config.ini"

# defaults if config missing
MODE="lite"
DIR_WORDLIST="/usr/share/wordlists/dirb/common.txt"
GOBUSTER_THREADS=30
KATANA_THREADS=15
NAABU_RATE=1000
NUCLEI_SEVERITY="high,critical"
NUCLEI_TEMPLATES=""
NUCLEI_EXCLUDE_TAGS=""

if [[ -f "$CONFIG_FILE" ]]; then
    echo -e "${GREEN}[+] Loading config.ini${RESET}"
    MODE=$(awk -F' = ' '/mode/ {print $2}' "$CONFIG_FILE")
    DIR_WORDLIST=$(awk -F' = ' '/dir_wordlist/ {print $2}' "$CONFIG_FILE")
    GOBUSTER_THREADS=$(awk -F' = ' '/gobuster_threads/ {print $2}' "$CONFIG_FILE")
    KATANA_THREADS=$(awk -F' = ' '/katana_threads/ {print $2}' "$CONFIG_FILE")
    NAABU_RATE=$(awk -F' = ' '/naabu_rate/ {print $2}' "$CONFIG_FILE")
    NUCLEI_SEVERITY=$(awk -F' = ' '/nuclei_severity/ {print $2}' "$CONFIG_FILE")
    NUCLEI_TEMPLATES=$(awk -F' = ' '/nuclei_templates/ {print $2}' "$CONFIG_FILE")
    NUCLEI_EXCLUDE_TAGS=$(awk -F' = ' '/nuclei_exclude_tags/ {print $2}' "$CONFIG_FILE")
else
    echo -e "${YELLOW}[!] No config.ini found — using default settings.${RESET}"
fi

# ---------- ARGUMENT PARSE ----------
TARGET="$1"
SCAN_MODE="$2"

if [[ -z "$TARGET" ]]; then
    echo -e "${YELLOW}Usage:${RESET} ./rec0nes4y.sh <domain> [--lite | --aggressive]"
    exit 0
fi

# override config using CLI
[[ "$SCAN_MODE" == "--lite" ]] && MODE="lite"
[[ "$SCAN_MODE" == "--aggressive" ]] && MODE="aggressive"

# ---------- OUTPUT SETUP ----------
OUT="rec0nes4y-$TARGET"
mkdir -p "$OUT"
cd "$OUT" || exit 1

echo -e "${BLUE}[>] Target:${RESET} $TARGET"
echo -e "${BLUE}[>] Mode:${RESET} $MODE"
echo -e "${GREEN}[+] Starting Automated Recon...${RESET}"
echo

# ---------- TOOL WARNING CHECK ----------
REQUIRED_TOOLS=("whois" "subfinder" "assetfinder" "httpx" "nmap" "whatweb" "gobuster" "hele" "nuclei" "naabu" "katana")
for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
        echo -e "${YELLOW}[!] Warning:${RESET} $tool not installed — module skipped."
    fi
done
echo

# ------------------------ SCANS BEGIN ------------------------

echo -e "${GREEN}[+] WHOIS Info${RESET}"
command -v whois &>/dev/null && whois "$TARGET" > whois.txt

echo -e "${GREEN}[+] Enumerating subdomains...${RESET}"
> subfinder.txt; > assetfinder.txt; > amass.txt
command -v subfinder &>/dev/null && subfinder -silent -d "$TARGET" | tee subfinder.txt &
command -v assetfinder &>/dev/null && assetfinder --subs-only "$TARGET" | tee assetfinder.txt &
command -v amass &>/dev/null && amass enum -passive -d "$TARGET" | tee amass.txt &
wait
cat subfinder.txt assetfinder.txt amass.txt | sort -u | grep -v '^\s*$' > subs_all.txt

echo

# ----------- Early EXIT if LITE MODE ----------
if [[ "$MODE" == "lite" ]]; then
    echo -e "${MAGENTA}[✓] Lite Mode Active — Fast Recon Only${RESET}"
    command -v httpx &>/dev/null && cat subs_all.txt | httpx -silent -status-code -title -tech-detect > alive.txt
    command -v whatweb &>/dev/null && whatweb "$TARGET" > whatweb.txt
    echo -e "${GREEN}Results stored in:${RESET} $OUT"
    exit 0
fi

# --------- AGGRESSIVE MODE CONTINUES ---------
echo -e "${GREEN}[+] Aggressive Mode Activated${RESET}"

# Alive
command -v httpx &>/dev/null && cat subs_all.txt | httpx -silent -status-code -title -tech-detect > alive.txt
awk '{print $1}' alive.txt > alive_urls.txt

# Naabu
command -v naabu &>/dev/null && awk -F/ '{print $3}' alive_urls.txt | sort -u > alive_hosts.txt && \
naabu -list alive_hosts.txt -rate "$NAABU_RATE" -silent -top-ports 100 | tee naabu.txt

# Nmap
command -v nmap &>/dev/null && nmap -Pn -sC -sV -T4 "$TARGET" -oN nmap_main.txt

# Tech
command -v whatweb &>/dev/null && whatweb "$TARGET" > whatweb_main.txt

# Gobuster
command -v gobuster &>/dev/null && \
gobuster dir -u "https://$TARGET" -w "$DIR_WORDLIST" -t "$GOBUSTER_THREADS" -o gobuster_main.txt

# HeLe
command -v hele &>/dev/null && \
echo "URL: https://$TARGET" | hele -crawl -deep > hele_raw.txt && \
grep -Eo '(http|https)://[^ ]+' hele_raw.txt | sort -u > hele_links.txt

# Katana
command -v katana &>/dev/null && katana -list alive_urls.txt -silent -threads "$KATANA_THREADS" -o katana_urls.txt

# Archive URLs
> archive_urls.txt
command -v waybackurls &>/dev/null && echo "$TARGET" | waybackurls >> archive_urls.txt
command -v gau &>/dev/null && echo "$TARGET" | gau >> archive_urls.txt
sort -u archive_urls.txt -o archive_urls.txt 2>/dev/null

# Nuclei
if command -v nuclei &>/dev/null; then
    NUCLEI_CMD="nuclei -l alive_urls.txt -severity $NUCLEI_SEVERITY -o nuclei_alive.txt"
    [[ -n "$NUCLEI_TEMPLATES" ]] && NUCLEI_CMD="$NUCLEI_CMD -t $NUCLEI_TEMPLATES"
    [[ -n "$NUCLEI_EXCLUDE_TAGS" ]] && NUCLEI_CMD="$NUCLEI_CMD -etags $NUCLEI_EXCLUDE_TAGS"
    eval "$NUCLEI_CMD"
fi

# ---------- END ----------
echo -e "${MAGENTA}"
echo "────────────────────────────────────────────────────────────"
echo "              Recon Completed — rec0nes4y"
echo "────────────────────────────────────────────────────────────"
echo -e "${BLUE}Results Saved To:${RESET} $OUT"
echo -e "${GREEN}Happy Hunting, Stay Ethical!${RESET}"
echo
