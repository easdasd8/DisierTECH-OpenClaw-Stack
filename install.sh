#!/usr/bin/env bash
# ============================================================================
#
#   ██████╗ ██╗███████╗██╗███████╗██████╗ ████████╗███████╗ ██████╗██╗  ██╗
#   ██╔══██╗██║██╔════╝██║██╔════╝██╔══██╗╚══██╔══╝██╔════╝██╔════╝██║  ██║
#   ██║  ██║██║███████╗██║█████╗  ██████╔╝   ██║   █████╗  ██║     ███████║
#   ██║  ██║██║╚════██║██║██╔══╝  ██╔══██╗   ██║   ██╔══╝  ██║     ██╔══██║
#   ██████╔╝██║███████║██║███████╗██║  ██║   ██║   ███████╗╚██████╗██║  ██║
#   ╚═════╝ ╚═╝╚══════╝╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝
#
#   🦀 OpenClaw Stack — One-Click Cloud Installer
#   🌐 https://disier.tech
#   🐙 https://github.com/disi3r/
#
#   Prepares any fresh Debian/Ubuntu VPS for production OpenClaw deployment.
#   Compatible with x86_64 (Intel/AMD) and ARM64 (Oracle Ampere, Graviton).
#
# ============================================================================

set -euo pipefail

# ─── Colors & Formatting ───────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ─── Helper Functions ──────────────────────────────────────────────────────────
info()    { echo -e "${BLUE}[ℹ]${NC} $1"; }
success() { echo -e "${GREEN}[✔]${NC} $1"; }
warn()    { echo -e "${YELLOW}[⚠]${NC} $1"; }
error()   { echo -e "${RED}[✖]${NC} $1"; exit 1; }
step()    { echo -e "\n${MAGENTA}${BOLD}━━━ $1 ━━━${NC}\n"; }

# ─── Root Check ────────────────────────────────────────────────────────────────
if [[ $EUID -ne 0 ]]; then
    error "This script must be run as root. Use: sudo bash install.sh"
fi

# ─── Banner ────────────────────────────────────────────────────────────────────
echo -e "${CYAN}"
cat << 'BANNER'

   ██████╗ ██╗███████╗██╗███████╗██████╗ ████████╗███████╗ ██████╗██╗  ██╗
   ██╔══██╗██║██╔════╝██║██╔════╝██╔══██╗╚══██╔══╝██╔════╝██╔════╝██║  ██║
   ██║  ██║██║███████╗██║█████╗  ██████╔╝   ██║   █████╗  ██║     ███████║
   ██║  ██║██║╚════██║██║██╔══╝  ██╔══██╗   ██║   ██╔══╝  ██║     ██╔══██║
   ██████╔╝██║███████║██║███████╗██║  ██║   ██║   ███████╗╚██████╗██║  ██║
   ╚═════╝ ╚═╝╚══════╝╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝

        🦀 OpenClaw Stack — One-Click Cloud Installer
        🌐 https://disier.tech
        📦 https://github.com/disi3r/DisierTECH-OpenClaw-Stack

BANNER
echo -e "${NC}"

# ─── Architecture Detection ───────────────────────────────────────────────────
step "1/8 · Detecting System Architecture"

ARCH=$(uname -m)
case "$ARCH" in
    x86_64)
        PLATFORM="x86_64"
        NODE_ARCH="x64"
        info "Detected: ${BOLD}x86_64${NC} (Intel/AMD)"
        ;;
    aarch64|arm64)
        PLATFORM="arm64"
        NODE_ARCH="arm64"
        info "Detected: ${BOLD}ARM64${NC} (Ampere/Graviton)"
        warn "ARM64 detected — build-essential will be installed for native module compilation."
        ;;
    *)
        error "Unsupported architecture: $ARCH. This script supports x86_64 and ARM64 only."
        ;;
esac

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_NAME=$ID
    OS_VERSION=$VERSION_ID
    info "Operating System: ${BOLD}${PRETTY_NAME}${NC}"
else
    error "Cannot detect OS. This script requires Debian or Ubuntu."
fi

# Verify supported OS
case "$OS_NAME" in
    debian|ubuntu) ;;
    *)
        warn "This script is optimized for Debian/Ubuntu. Proceeding on $OS_NAME, but results may vary."
        ;;
esac

success "Architecture detection complete."

# ─── System Update ─────────────────────────────────────────────────────────────
step "2/8 · Updating System Packages"

export DEBIAN_FRONTEND=noninteractive

info "Updating package lists..."
apt-get update -qq

info "Upgrading installed packages..."
apt-get upgrade -y -qq

info "Installing essential build tools..."
apt-get install -y -qq \
    curl \
    wget \
    gnupg \
    ca-certificates \
    lsb-release \
    software-properties-common \
    build-essential \
    git \
    unzip \
    jq \
    htop \
    net-tools \
    ufw \
    fail2ban

success "System packages updated and essentials installed."

# ─── Python 3 ──────────────────────────────────────────────────────────────────
step "3/8 · Installing Python 3"

if command -v python3 &>/dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1)
    info "Python already installed: ${BOLD}$PYTHON_VERSION${NC}"
else
    info "Installing Python 3..."
    apt-get install -y -qq python3 python3-pip python3-venv
    success "Python 3 installed."
fi

# Ensure python3 is available for node-gyp
if ! command -v python3 &>/dev/null; then
    error "Python 3 installation failed. node-gyp requires Python for native module compilation."
fi

success "Python 3 ready for node-gyp builds."

# ─── Node.js LTS ──────────────────────────────────────────────────────────────
step "4/8 · Installing Node.js LTS"

if command -v node &>/dev/null; then
    NODE_CURRENT=$(node --version 2>&1)
    info "Node.js already installed: ${BOLD}$NODE_CURRENT${NC}"
    warn "Checking if this is an LTS version..."
fi

# Install Node.js LTS via NodeSource (supports both x86_64 and ARM64)
NODE_MAJOR=22  # LTS as of 2026

info "Setting up NodeSource repository for Node.js ${NODE_MAJOR}.x LTS..."

# Remove old NodeSource setup if present
rm -f /etc/apt/sources.list.d/nodesource.list
rm -f /usr/share/keyrings/nodesource.gpg

# Install using the official NodeSource script
curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash -

info "Installing Node.js ${NODE_MAJOR}.x..."
apt-get install -y -qq nodejs

# Verify
NODE_VERSION=$(node --version)
NPM_VERSION=$(npm --version)

success "Node.js ${NODE_VERSION} installed (npm ${NPM_VERSION})"

# ─── Docker Engine + Compose ──────────────────────────────────────────────────
step "5/8 · Installing Docker Engine & Compose"

if command -v docker &>/dev/null; then
    DOCKER_VERSION=$(docker --version 2>&1)
    info "Docker already installed: ${BOLD}$DOCKER_VERSION${NC}"
else
    info "Installing Docker via official repository..."

    # Add Docker's official GPG key
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/$OS_NAME/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$OS_NAME \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt-get update -qq
    apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Start and enable Docker
    systemctl start docker
    systemctl enable docker

    success "Docker Engine installed and started."
fi

# Verify Docker Compose
if docker compose version &>/dev/null; then
    COMPOSE_VERSION=$(docker compose version --short)
    success "Docker Compose ${COMPOSE_VERSION} ready."
else
    warn "Docker Compose plugin not found. Installing..."
    apt-get install -y -qq docker-compose-plugin
fi

# ─── 2 GB Swap File ───────────────────────────────────────────────────────────
step "6/8 · Configuring 2 GB Swap File"

# Check total RAM
TOTAL_RAM_MB=$(free -m | awk '/^Mem:/{print $2}')
info "Total RAM: ${BOLD}${TOTAL_RAM_MB} MB${NC}"

if swapon --show | grep -q '/swapfile'; then
    SWAP_SIZE=$(swapon --show | awk '/\/swapfile/{print $3}')
    info "Swap file already active: ${BOLD}${SWAP_SIZE}${NC}"
    warn "Skipping swap creation."
else
    info "Creating 2 GB swap file..."

    # Create swap file
    fallocate -l 2G /swapfile 2>/dev/null || dd if=/dev/zero of=/swapfile bs=1M count=2048 status=progress
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile

    # Make persistent
    if ! grep -q '/swapfile' /etc/fstab; then
        echo '/swapfile none swap sw 0 0' >> /etc/fstab
        info "Swap added to /etc/fstab for persistence."
    fi

    success "2 GB swap file created and activated."
fi

# Tune swappiness
info "Setting vm.swappiness=10 (prefer RAM over swap)..."
sysctl vm.swappiness=10
if ! grep -q 'vm.swappiness=10' /etc/sysctl.conf; then
    echo 'vm.swappiness=10' >> /etc/sysctl.conf
fi

success "Swap configuration complete."

# ─── TCP & Kernel Tuning ──────────────────────────────────────────────────────
step "7/8 · Applying TCP & Kernel Optimizations"

info "Optimizing kernel parameters for high-concurrency automation..."

SYSCTL_CONF="/etc/sysctl.d/99-openclaw-tuning.conf"

cat > "$SYSCTL_CONF" << 'TUNING'
# ============================================================================
# DisierTECH OpenClaw Stack — Kernel Tuning
# Optimized for high-concurrency Node.js automation workloads
# https://disier.tech
# ============================================================================

# ─── Memory Management ─────────────────────────────────────────────────────
# Prefer RAM over swap (already set, but enforce here)
vm.swappiness = 10

# Reduce tendency to swap out inode/dentry caches (important for SQLite FTS5)
vm.vfs_cache_pressure = 50

# Allow overcommit to prevent false OOM kills during npm install
vm.overcommit_memory = 1

# ─── Network / TCP Optimization ────────────────────────────────────────────
# Increase max connections queue (webhook/API servers)
net.core.somaxconn = 65535

# Increase network device backlog for burst traffic
net.core.netdev_max_backlog = 65535

# Enable TCP Fast Open (client + server)
net.ipv4.tcp_fastopen = 3

# Reuse TIME_WAIT sockets for new connections (critical for high-freq API calls)
net.ipv4.tcp_tw_reuse = 1

# Reduce FIN_WAIT timeout (free sockets faster)
net.ipv4.tcp_fin_timeout = 15

# Enable TCP keepalive (detect dead connections)
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_keepalive_intvl = 30
net.ipv4.tcp_keepalive_probes = 5

# Increase local port range for outgoing connections
net.ipv4.ip_local_port_range = 1024 65535

# Increase max SYN backlog
net.ipv4.tcp_max_syn_backlog = 65535

# ─── File Descriptors ──────────────────────────────────────────────────────
# Increase max open files system-wide (Node.js uses many file descriptors)
fs.file-max = 2097152
fs.nr_open = 2097152

# ─── Connection Tracking ───────────────────────────────────────────────────
# Increase conntrack table for Docker/NAT environments
net.netfilter.nf_conntrack_max = 131072
TUNING

# Apply settings
sysctl -p "$SYSCTL_CONF" 2>/dev/null || true

# Increase open file limits for the current session and persist
cat > /etc/security/limits.d/99-openclaw.conf << 'LIMITS'
# DisierTECH OpenClaw — File descriptor limits
*  soft  nofile  65535
*  hard  nofile  65535
root  soft  nofile  65535
root  hard  nofile  65535
LIMITS

success "Kernel and TCP tuning applied."

# ─── Firewall Setup ───────────────────────────────────────────────────────────
step "8/8 · Configuring Firewall (UFW)"

info "Setting up UFW firewall rules..."

# Reset to defaults
ufw --force reset >/dev/null 2>&1

# Default policies
ufw default deny incoming
ufw default allow outgoing

# Allow SSH (standard port — user should change to 22022 for security)
ufw allow 22/tcp comment 'SSH'

# Allow OpenClaw Dashboard
ufw allow 3000/tcp comment 'OpenClaw Dashboard'

# Allow HTTP/HTTPS for webhooks
ufw allow 80/tcp comment 'HTTP'
ufw allow 443/tcp comment 'HTTPS'

# Enable firewall
ufw --force enable

success "Firewall configured and enabled."

# ─── Summary ──────────────────────────────────────────────────────────────────
echo ""
echo -e "${CYAN}${BOLD}"
cat << 'SUMMARY'
╔══════════════════════════════════════════════════════════════════════╗
║                                                                      ║
║   ✅  DisierTECH OpenClaw Stack — Installation Complete!             ║
║                                                                      ║
╚══════════════════════════════════════════════════════════════════════╝
SUMMARY
echo -e "${NC}"

echo -e "${GREEN}${BOLD}Environment Summary:${NC}"
echo -e "  📐 Architecture:   ${BOLD}$PLATFORM${NC}"
echo -e "  🖥️  OS:             ${BOLD}${PRETTY_NAME}${NC}"
echo -e "  🟢 Node.js:        ${BOLD}$(node --version)${NC}"
echo -e "  📦 npm:            ${BOLD}$(npm --version)${NC}"
echo -e "  🐍 Python:         ${BOLD}$(python3 --version 2>&1)${NC}"
echo -e "  🐳 Docker:         ${BOLD}$(docker --version 2>&1 | awk '{print $3}' | tr -d ',')${NC}"
echo -e "  🐳 Compose:        ${BOLD}$(docker compose version --short 2>/dev/null || echo 'N/A')${NC}"
echo -e "  💾 Swap:           ${BOLD}$(swapon --show | awk 'NR==2{print $3}' || echo '2G')${NC}"
echo -e "  🔒 Firewall:       ${BOLD}UFW Active${NC}"
echo ""
echo -e "${YELLOW}${BOLD}Next Steps:${NC}"
echo -e "  1. Clone the OpenClaw Stack:  ${CYAN}git clone https://github.com/disi3r/DisierTECH-OpenClaw-Stack.git${NC}"
echo -e "  2. Navigate to the directory:  ${CYAN}cd DisierTECH-OpenClaw-Stack${NC}"
echo -e "  3. Start OpenClaw:             ${CYAN}docker compose up -d${NC}"
echo -e "  4. View logs:                  ${CYAN}docker compose logs -f openclaw${NC}"
echo ""
echo -e "${MAGENTA}${BOLD}Need premium hosting? DisierTECH recommends:${NC}"
echo -e "  🔵 DigitalOcean (\$200 free):   ${CYAN}https://m.do.co/c/18d7654d20a3${NC}"
echo -e "  🟠 Hostinger VPS (~\$4/mo):     ${CYAN}https://hostinger.es?REFERRALCODE=DisierTECH${NC}"
echo ""
echo -e "  ${BOLD}🌐 https://disier.tech${NC}"
echo ""
