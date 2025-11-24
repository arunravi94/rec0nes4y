<div align="center">
   <a href="https://github.com/yourusername/rec0nes4y">
      <img src="YOUR-BANNER-IMAGE-LINK-HERE" height="250" width="600" />
   </a>
</div>

<br><br><br>

<div align="center">

| rec0nes4y | Automated Recon Tool | For Bug Bounty & Pentesting |
|----------|------------------------|-----------------------------|
| `R` | = | `Recon` |
| `E` | = | `Enumeration` |
| `C` | = | `Crawling` |
| `0` | = | `Automation` |
| `N` | = | `Network Scan` |
| `E` | = | `Endpoint Discovery` |
| `S` | = | `Security Scan` |
| `4Y` | = | `For You` |

> **rec0nes4y** is a fully automated recon framework that performs **subdomain discovery → port/service scan → tech fingerprint → directory scan → JS endpoint extraction → vulnerability scan** — all in **ONE COMMAND**.  
<br><br> *`Made by`* – **YOUR NAME OR TEAM**
</div>

<hr>
<br><br><br>

| Feature | About |
|--------|-------|
| `Subdomain Enumeration` | Finds subdomains using Subfinder + Assetfinder |
| `Alive Host Detection` | httpx checks which hosts are active |
| `Port & Service Scan` | nmap discovers open ports and running services |
| `Technology Fingerprint` | whatweb identifies frameworks, servers & CMS |
| `Directory Bruteforce` | gobuster discovers hidden paths |
| `JS & Endpoint Extraction` | HeLe crawls JS files, API endpoints & parameters |
| `Vulnerability Scan` | nuclei finds common critical vulnerabilities |
| `Organized Reports` | All results saved in a clean directory |
| `One Command Automation` | Fully hands-free end-to-end recon |

<br>
<hr>
<br>

| Tool | Purpose |
|------|---------|
| `whois` | OSINT base info |
| `subfinder` | Subdomain enumeration |
| `assetfinder` | Subdomain enumeration |
| `httpx` | Alive verification + title + tech |
| `nmap` | Port & service scan |
| `whatweb` | Technology identification |
| `gobuster` | Directory brute force |
| `HeLe` | JS endpoint crawling |
| `nuclei` | Vulnerability scan |

<br>
<hr>
<br>

## 🚀 Installation

### Clone the repository
```bash
git clone https://github.com/arunravi94/rec0nes4y.git
cd rec0nes4y
chmod +x install.sh
./install.sh
chmod +x rec0nes4y.sh

<br>
<hr>
<br>

##  ▶️ Usage

./rec0nes4y.sh example.com

## 📂 Output Files

rec0nes4y-example.com/
├── alive.txt
├── assetfinder.txt
├── gobuster.txt
├── hele_links.txt
├── hele_raw.txt
├── nmap.txt
├── nuclei.txt
├── subfinder.txt
├── subs_all.txt
├── whatweb.txt
└── whois.txt

## ⚠️ Warning

[!WARNING]
rec0nes4y is for educational & ethical hacking purposes only.
Use this tool only on systems you own or have written permission to test.
Unauthorized scanning of third-party systems is illegal & punishable by law.

