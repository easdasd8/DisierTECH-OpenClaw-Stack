<p align="center">
  <img src="https://img.shields.io/badge/DisierTECH-OpenClaw%20Stack-blueviolet?style=for-the-badge&logo=github" alt="DisierTECH OpenClaw Stack"/>
  <br/>
  <img src="https://img.shields.io/badge/Node.js-LTS-339933?style=flat-square&logo=node.js&logoColor=white" alt="Node.js LTS"/>
  <img src="https://img.shields.io/badge/Docker-Ready-2496ED?style=flat-square&logo=docker&logoColor=white" alt="Docker Ready"/>
  <img src="https://img.shields.io/badge/ARM64%20%7C%20x86__64-Compatible-orange?style=flat-square" alt="Multi-Arch"/>
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="MIT License"/>
</p>

<h1 align="center">🦀 DisierTECH — OpenClaw Stack</h1>

<p align="center">
  <b>The production-ready cloud deployment guide for OpenClaw autonomous agents.</b><br/>
  One-click installation · Multi-cloud support · Kernel-tuned performance
</p>

<p align="center">
  <a href="https://disier.tech">🌐 disier.tech</a> · 
  <a href="https://github.com/disi3r/">GitHub</a> · 
  <a href="https://www.linkedin.com/in/disier/">LinkedIn</a>
</p>

---

## 📖 Table of Contents

- [Introduction](#-introduction)
- [Cloud Infrastructure Guide](#-cloud-infrastructure-guide)
  - [DigitalOcean](#-digitalocean--recommended)
  - [Google Cloud Platform (GCP)](#-google-cloud-platform-gcp)
  - [Oracle Cloud Infrastructure (OCI)](#-oracle-cloud-infrastructure-oci)
  - [Microsoft Azure](#-microsoft-azure)
  - [Hostinger VPS](#-hostinger-vps--best-value)
- [Cloud Provider Comparison](#-cloud-provider-comparison)
- [Paid Hosting Recommendation](#-paid-hosting-recommendation)
- [One-Click Installation](#-one-click-installation)
- [Docker Compose Setup](#-docker-compose-setup)
- [Troubleshooting](#-troubleshooting)
- [Contact & Socials](#-contact--socials)
- [License](#-license)

---

## 🧠 Introduction

**OpenClaw** (formerly known as *Moltbot* and *ClawdBot*) is a persistent, local-first autonomous AI agent framework built on **Node.js**. Unlike cloud-hosted AI APIs, OpenClaw runs **on your infrastructure** — maintaining its own state, managing a local vector database (SQLite FTS5), executing operating system-level commands, and operating as a true digital surrogate.

### Why Cloud Nodes Matter

Running OpenClaw on your laptop works great for development, but production agents need **24/7 uptime**. Your machine sleeps, reboots, and disconnects — severing the agent's connection to the world. A cloud VPS provides:

| Requirement | Why It Matters |
|:---|:---|
| **Persistent Uptime** | Webhooks, cron jobs, and email monitors run uninterrupted |
| **RAM Availability** | OpenClaw loads contexts + vector indices into memory (300MB–700MB+) |
| **NVMe/SSD Storage** | SQLite FTS5 hybrid retrieval demands low-latency disk I/O |
| **Single-Core Speed** | Node.js is single-threaded; fast CPU = responsive agent |
| **Security Isolation** | OpenClaw has shell execution capabilities — never run on a shared personal machine in production |

This repository provides everything you need to deploy OpenClaw on any major cloud provider, with **kernel-optimized configurations** designed by [DisierTECH](https://disier.tech).

---

## ☁️ Cloud Infrastructure Guide

### 🔵 DigitalOcean · ★ Recommended

<table>
  <tr>
    <td><strong>💰 Credits</strong></td>
    <td><strong>$200 FREE</strong> for 60 days via referral</td>
  </tr>
  <tr>
    <td><strong>🎓 Students</strong></td>
    <td>$200 for <strong>1 year</strong> via GitHub Student Developer Pack</td>
  </tr>
  <tr>
    <td><strong>🏗️ Architecture</strong></td>
    <td>x86_64 (KVM-based Droplets)</td>
  </tr>
  <tr>
    <td><strong>⚡ 1-Click Deploy</strong></td>
    <td>Available in the DO Marketplace for OpenClaw</td>
  </tr>
</table>

> **👉 [Get $200 FREE Credit on DigitalOcean](https://m.do.co/c/18d7654d20a3)**

#### Step-by-Step Setup

1. **Create Account** → Sign up via [this referral link](https://m.do.co/c/18d7654d20a3) to claim your **$200 credit (60 days)**.
2. **Create a Droplet:**
   - **Image:** Debian 12 (Bookworm) or Ubuntu 24.04
   - **Plan:** Basic — $6/mo (1 vCPU, 1 GB RAM, 25 GB SSD) or $12/mo (1 vCPU, 2 GB RAM)
   - **Region:** Choose closest to your users
   - **Authentication:** SSH Key (never use passwords)
3. **Connect:** `ssh root@your-droplet-ip`
4. **Run the Installer:**
   ```bash
   curl -fsSL https://raw.githubusercontent.com/disi3r/DisierTECH-OpenClaw-Stack/main/install.sh | bash
   ```
5. **Deploy OpenClaw:**
   ```bash
   docker compose up -d
   ```

#### Why DigitalOcean?

- **Predictable performance** — No CPU throttling or "noisy neighbor" issues like burstable instances
- **1-Click marketplace** — Pre-configured OpenClaw images available
- **PayPal accepted** — $5 pre-payment verification (no credit card required)
- **Superior DX** — The cleanest dashboard and API in the industry

---

### 🟡 Google Cloud Platform (GCP)

<table>
  <tr>
    <td><strong>💰 Trial Credits</strong></td>
    <td><strong>$300 FREE</strong> for 90 days</td>
  </tr>
  <tr>
    <td><strong>♾️ Always Free</strong></td>
    <td><strong>e2-micro</strong> — 2 vCPUs (shared), 1 GB RAM, 30 GB disk</td>
  </tr>
  <tr>
    <td><strong>🏗️ Architecture</strong></td>
    <td>x86_64 (shared-core)</td>
  </tr>
  <tr>
    <td><strong>📍 Free Regions</strong></td>
    <td>us-west1, us-central1, us-east1 only</td>
  </tr>
</table>

> 🔗 [Sign up for Google Cloud Free Tier](https://cloud.google.com/free)

#### Step-by-Step Setup

1. **Create Account** → Go to [cloud.google.com/free](https://cloud.google.com/free) and claim your **$300 trial credit**.
2. **Strategy:** Use the $300 credit to provision a more powerful **e2-medium (4 GB RAM)** for initial setup and testing. After 90 days, downsize to the **e2-micro (Always Free)**.
3. **Create a VM Instance:**
   - **Machine type:** `e2-micro` (Always Free) or `e2-medium` (during trial)
   - **Boot disk:** Debian 12, 30 GB Standard Persistent Disk
   - **Region:** `us-central1` (recommended for free tier)
   - **Firewall:** Allow HTTP/HTTPS traffic
4. **Connect:** Use the GCP Console SSH button or `gcloud compute ssh`
5. **⚠️ MANDATORY — Create Swap** (the e2-micro has only 1 GB RAM):
   ```bash
   curl -fsSL https://raw.githubusercontent.com/disi3r/DisierTECH-OpenClaw-Stack/main/install.sh | bash
   ```
   The install script automatically creates a **2 GB swap file** and tunes `vm.swappiness=10`.

#### ⚠️ Important: 1 GB RAM Limitation

The e2-micro instance has only **1 GB of RAM**. Without swap, OpenClaw **will crash** during:
- `npm install` (building native modules)
- Vector database re-indexing
- Memory-intensive skills (image processing, browser automation)

The `install.sh` script handles swap creation automatically.

---

### 🔴 Oracle Cloud Infrastructure (OCI)

<table>
  <tr>
    <td><strong>💰 Trial Credits</strong></td>
    <td>$300 for 30 days</td>
  </tr>
  <tr>
    <td><strong>♾️ Always Free</strong></td>
    <td><strong>Ampere A1</strong> — Up to <strong>4 OCPUs, 24 GB RAM</strong>, 200 GB Block Storage</td>
  </tr>
  <tr>
    <td><strong>🏗️ Architecture</strong></td>
    <td><strong>ARM64</strong> (Ampere Altra)</td>
  </tr>
  <tr>
    <td><strong>⚠️ Major Risk</strong></td>
    <td>Out of Host Capacity errors + Idle Reclamation Policy</td>
  </tr>
</table>

> 🔗 [Sign up for Oracle Cloud Free Tier](https://www.oracle.com/cloud/free/)

#### Step-by-Step Setup

1. **Create Account** → Go to [oracle.com/cloud/free](https://www.oracle.com/cloud/free/)
   - ⚠️ **Strict verification** — Requires a real credit/debit card (fintech/prepaid cards often rejected)
2. **Create a Compute Instance:**
   - **Shape:** `VM.Standard.A1.Flex` (Ampere ARM)
   - **Configuration:** 4 OCPUs, 24 GB RAM (max free allocation)
   - **Image:** Canonical Ubuntu 24.04 aarch64 or Oracle Linux 9 aarch64
   - **Storage:** 200 GB Block Volume
   - **Region:** Try less popular regions (São Paulo, Jeddah) if you get "Out of Host Capacity" errors in popular ones
3. **Open Ports** — See [Troubleshooting: Oracle VCN](#oracle-cloud-vcn-ports-not-opening)
4. **Install:**
   ```bash
   curl -fsSL https://raw.githubusercontent.com/disi3r/DisierTECH-OpenClaw-Stack/main/install.sh | bash
   ```

#### ⚠️ Critical: ARM64 Compatibility

Oracle's free tier uses **ARM64 processors**. Some Node.js native modules may lack pre-built ARM binaries, causing `npm install` to attempt compilation from source. The `install.sh` script pre-installs `build-essential` and `python3` to handle this, but you may encounter `node-gyp` errors. Docker multi-arch images are the recommended mitigation.

#### ⚠️ Critical: Idle Reclamation Policy

Oracle **will terminate** your Always Free instance if it idles for 7 days. Thresholds:

| Metric | Minimum Required |
|:---|:---|
| CPU Utilization (95th percentile) | > 10% |
| Network Utilization | > 10% |
| Memory Utilization | > 10% |

**Mitigation:** Set up a cron-based keep-alive script that generates periodic CPU and network activity. OpenClaw's active agent processes usually satisfy these thresholds naturally.

---

### 🟣 Microsoft Azure

<table>
  <tr>
    <td><strong>🎓 Students</strong></td>
    <td><strong>$100 FREE</strong> for 12 months — <strong>NO credit card needed!</strong></td>
  </tr>
  <tr>
    <td><strong>💰 Standard Trial</strong></td>
    <td>$200 for 30 days + 12 months of free services</td>
  </tr>
  <tr>
    <td><strong>♾️ Best Free VM</strong></td>
    <td><strong>B2pts v2</strong> — 2 vCPUs, <strong>4 GB RAM</strong> (ARM64) · 750 hrs/mo for 12 months</td>
  </tr>
</table>

> 🔗 [Azure for Students (No CC Required)](https://azure.microsoft.com/en-us/free/students/)  
> 🔗 [Azure Free Account](https://azure.microsoft.com/en-us/free/)

#### Step-by-Step Setup

1. **Students:** Go to [azure.microsoft.com/free/students](https://azure.microsoft.com/en-us/free/students/) and verify with your `.edu` email. **No credit card required.**
2. **Non-Students:** Go to [azure.microsoft.com/free](https://azure.microsoft.com/en-us/free/) and claim $200 for 30 days.
3. **Create a Virtual Machine:**
   - **Size:** `B2pts v2` (2 vCPUs, 4 GB RAM, ARM64) or `B2ats v2` (AMD x86, 4 GB RAM)
   - **Image:** Debian 12 or Ubuntu 24.04
   - **Authentication:** SSH public key
   - ⚠️ Ensure you select the VM from the **"Free Services"** path — the portal defaults to paid options!
4. **Connect & Install:**
   ```bash
   ssh azureuser@your-vm-ip
   curl -fsSL https://raw.githubusercontent.com/disi3r/DisierTECH-OpenClaw-Stack/main/install.sh | bash
   ```

#### Why Azure for Students?

- **No credit card barrier** — The only major cloud provider that doesn't require one
- **4 GB RAM on B2pts v2** — 4× more memory than GCP's free tier
- **Renewable annually** — As long as you maintain student status
- **$100 credit** — Enough to run premium VMs for months of testing

---

### 🟠 Hostinger VPS · ★ Best Value

<table>
  <tr>
    <td><strong>💰 Price</strong></td>
    <td>From <strong>~$4.24/mo</strong> (with coupon)</td>
  </tr>
  <tr>
    <td><strong>🏗️ KVM 1</strong></td>
    <td>1 vCPU, <strong>4 GB RAM</strong>, <strong>50 GB NVMe</strong></td>
  </tr>
  <tr>
    <td><strong>🏗️ KVM 2</strong></td>
    <td>2 vCPUs, <strong>8 GB RAM</strong>, <strong>100 GB NVMe</strong></td>
  </tr>
  <tr>
    <td><strong>💾 Storage</strong></td>
    <td>NVMe SSD (fastest for vector DB operations)</td>
  </tr>
  <tr>
    <td><strong>🔙 Trial</strong></td>
    <td>30-day money-back guarantee</td>
  </tr>
</table>

> **👉 [Get Hostinger VPS with DisierTECH Referral](https://hostinger.es?REFERRALCODE=DisierTECH)**

> 💡 **Coupon:** Use code `CEVPS` at checkout for up to **72% OFF**.

#### Step-by-Step Setup

1. **Purchase a Plan** → Go to [Hostinger VPS](https://hostinger.es?REFERRALCODE=DisierTECH) and select **KVM 1** ($4.24/mo) or **KVM 2** ($6.37/mo).
2. **Apply Coupon:** Enter `CEVPS` at checkout for maximum discount.
3. **Configure Your Server:**
   - **OS:** Debian 12 (Bookworm) — recommended for minimal overhead
   - **Location:** Choose closest data center
4. **Connect & Install:**
   ```bash
   ssh root@your-hostinger-ip
   curl -fsSL https://raw.githubusercontent.com/disi3r/DisierTECH-OpenClaw-Stack/main/install.sh | bash
   ```

#### Why Hostinger?

- **NVMe storage** — Superior IOPS for SQLite FTS5 vector search (faster agent memory recall)
- **KVM isolation** — Dedicated resources, not shared/burstable
- **4 GB RAM for ~$4/mo** — 4× the RAM of GCP's free tier at minimal cost
- **No reclamation anxiety** — Unlike Oracle, your server won't be terminated for idling

---

## 📊 Cloud Provider Comparison

| Feature | Oracle Cloud | Google Cloud | Azure (Student) | DigitalOcean | Hostinger |
|:---|:---:|:---:|:---:|:---:|:---:|
| **Model** | Always Free | Always Free | 12 Months Free | Credit Trial | Paid |
| **Instance** | Ampere A1 | e2-micro | B2pts v2 / B1s | Basic Droplet | KVM 1 / KVM 2 |
| **CPU Arch** | ARM64 | x86_64 (Shared) | ARM64 / x86_64 | x86_64 | x86_64 (KVM) |
| **vCPUs** | **4 OCPUs** | 2 (0.25–2.0) | 2 | 1 | 1–2 |
| **RAM** | **24 GB** 🏆 | 1 GB | **4 GB** | 512 MB–1 GB | **4–8 GB** |
| **Storage** | 200 GB Block | 30 GB HDD/SSD | 64 GB | SSD (Paid) | 50–100 GB **NVMe** |
| **Bandwidth** | 10 TB/mo | 1 GB Egress | 15 GB Egress | 1 TB | 4 TB–Unlimited |
| **Credits** | $300 (30 days) | $300 (90 days) | **$100 (12 mo)** | **$200 (60 days)** | N/A |
| **CC Required?** | Yes (Strict) | Yes | **No (Student)** ✅ | CC or PayPal | Pre-payment |
| **Availability** | ⚠️ Low | ✅ High | ✅ High | ✅ High | ✅ High |
| **Major Risk** | Reclamation | OOM Kills | 12-Month Expiry | Cost after trial | No free tier |
| **Best For** | Power Users | Minimalists | **Students** | **Developers** | **Value/Perf** |

---

## 💡 Paid Hosting Recommendation

When free trials expire, you need **reliable, predictable infrastructure**. Here are the top picks from DisierTECH:

### 🥇 DigitalOcean — Best for Developers

> **👉 [Claim $200 FREE Credit](https://m.do.co/c/18d7654d20a3)**

- Start free with $200 in credit for 60 days
- Students get $200 for **1 full year** via GitHub Education
- Clean dashboard, robust API, and 1-click OpenClaw marketplace
- Consistent CPU performance (no burstable throttling)
- **Recommended Plan:** $6/mo Droplet (1 vCPU, 1 GB RAM) — runs OpenClaw stable with swap

### 🥇 Hostinger — Best Value for Long-Term Hosting

> **👉 [Get Hostinger VPS](https://hostinger.es?REFERRALCODE=DisierTECH)** — Use code `CEVPS` for up to 72% OFF

- **4 GB RAM + NVMe SSD for ~$4.24/mo** — Unmatched value
- KVM virtualization with dedicated resources
- NVMe storage means faster vector database queries and agent startup
- 30-day money-back guarantee
- **Recommended Plan:** KVM 1 for solo agents, KVM 2 for multi-account setups

### Quick Decision Matrix

| Your Situation | Recommended Provider |
|:---|:---|
| 🎓 Student with `.edu` email | **Azure for Students** (free, no CC) |
| 💻 Developer who wants it easy | **[DigitalOcean](https://m.do.co/c/18d7654d20a3)** ($200 free credit) |
| 💰 Best bang for your buck | **[Hostinger KVM 1](https://hostinger.es?REFERRALCODE=DisierTECH)** (~$4/mo) |
| 🧪 Want maximum free resources | **Oracle Cloud** (24 GB RAM, if available) |
| 🆓 Free forever, minimal setup | **Google Cloud e2-micro** (1 GB RAM + swap) |

---

## 🚀 One-Click Installation

The **DisierTECH install script** prepares any fresh Linux server for OpenClaw in a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/disi3r/DisierTECH-OpenClaw-Stack/main/install.sh | bash
```

### What It Does

| Step | Description |
|:---|:---|
| 🎨 Branding | Displays the DisierTECH ASCII banner |
| 🔍 Architecture Detection | Auto-detects x86_64 vs ARM64 |
| 📦 System Update | Updates package manager and installs essentials |
| 🟢 Node.js LTS | Installs via NodeSource (ARM64 compatible) |
| 🐍 Python 3 | Required for `node-gyp` native module builds |
| 🐳 Docker + Compose | Installs Docker Engine + Compose plugin |
| 💾 2 GB Swap File | Creates and activates swap (critical for 1 GB instances) |
| ⚡ Kernel Tuning | TCP optimizations + `vm.swappiness=10` for high-concurrency |
| 🔒 Security | Configures UFW firewall with sensible defaults |

> See [`install.sh`](./install.sh) for the full script.

---

## 🐳 Docker Compose Setup

After running `install.sh`, use this `docker-compose.yml` to deploy OpenClaw:

```yaml
services:
  openclaw:
    image: openclaw/gateway:latest
    container_name: openclaw_agent
    restart: unless-stopped
    network_mode: "host"
    volumes:
      - ~/.openclaw:/root/.openclaw        # Persist agent identity & keys
      - ./workspace:/root/workspace         # Agent's working directory
    environment:
      - NODE_ENV=production
      - AGENT_secret_key=${SECRET_KEY}
    deploy:
      resources:
        limits:
          memory: 900M   # Leave headroom for OS on 1 GB instances
          cpus: '1.5'    # Limit CPU on shared-core instances
```

**Launch:**

```bash
docker compose up -d
```

**View logs:**

```bash
docker compose logs -f openclaw
```

---

## 🔧 Troubleshooting

### Oracle Cloud: VCN Ports Not Opening

Oracle Cloud has **two layers** of firewall rules. Opening a port in `iptables` alone is **not enough**.

1. **Security List (VCN Level):**
   - Go to **Networking → Virtual Cloud Networks → Your VCN → Security Lists**
   - Add an **Ingress Rule:**
     - Source CIDR: `0.0.0.0/0`
     - Protocol: TCP
     - Destination Port Range: `3000` (OpenClaw Dashboard)
2. **OS Firewall (iptables):**
   ```bash
   sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 3000 -j ACCEPT
   sudo netfilter-persistent save
   ```

### GCP / Azure: Out of Memory (OOM) Crashes

**Symptom:** OpenClaw process silently stops. `dmesg | grep -i oom` shows kill events.

**Fix:** Ensure the `install.sh` script ran successfully and created swap:

```bash
# Verify swap is active
free -h

# If no swap, create manually:
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
sudo sysctl vm.swappiness=10
```

### Oracle Cloud: Idle Instance Reclamation

**Symptom:** Your Always Free instance is terminated after 7 days of low usage.

**Fix:** Set up a keep-alive cron job:

```bash
# Edit crontab
crontab -e

# Add this line (runs CPU stress every 6 hours for 2 minutes):
0 */6 * * * /usr/bin/timeout 120 /usr/bin/yes > /dev/null 2>&1
```

### ARM64: `npm install` Fails with `node-gyp` Errors

**Symptom:** Native modules fail to compile on Oracle ARM instances.

**Fix:** Ensure build tools are installed:

```bash
sudo apt install -y build-essential python3 python3-pip libx11-dev
```

Alternatively, use Docker multi-arch images which handle cross-compilation automatically.

### Docker: Permission Denied

**Fix:** Ensure your user is in the `docker` group:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

### SSH: Connection Refused After Changing Port

**Fix:** Ensure the new SSH port is allowed in the firewall **before** disconnecting:

```bash
sudo ufw allow 22022/tcp
sudo ufw reload
```

---

## 👨‍💻 Contact & Socials

<table>
  <tr>
    <td align="center"><strong>Daniel Sánchez</strong><br/><em>(disier)</em></td>
  </tr>
</table>

| Platform | Link |
|:---|:---|
| 🌐 **Website** | [disier.tech](https://disier.tech) |
| 💼 **LinkedIn** | [linkedin.com/in/disier](https://www.linkedin.com/in/disier/) |
| 🐙 **GitHub** | [github.com/disi3r](https://github.com/disi3r/) |

### Affiliate & Referral Links

| Provider | Link | Benefit |
|:---|:---|:---|
| 🔵 **DigitalOcean** | [m.do.co/c/18d7654d20a3](https://m.do.co/c/18d7654d20a3) | **$200 free credit** (60 days) |
| 🟠 **Hostinger** | [hostinger.es?REFERRALCODE=DisierTECH](https://hostinger.es?REFERRALCODE=DisierTECH) | Premium VPS from ~$4/mo |

---

## 📄 License

This project is licensed under the [MIT License](./LICENSE).

---

<p align="center">
  <b>Built with 🧠 by <a href="https://disier.tech">DisierTECH</a></b><br/>
  <sub>If this guide helped you, consider using the referral links above — it supports the project at no extra cost to you. 🙏</sub>
</p>
