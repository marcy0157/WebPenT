#!/bin/bash

# WebPenTest Framework - Tool Installation Script
# This script installs all required tools for the penetration testing framework

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_banner() {
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║                 WebPenTest Framework Installer                ║"
    echo "║                     Tool Installation Script                  ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "This script must be run as root (use sudo)"
        exit 1
    fi
}

check_kali() {
    if [[ ! -f /etc/os-release ]] || ! grep -q "kali" /etc/os-release; then
        print_warning "This script is designed for Kali Linux"
        print_warning "Some packages may not be available on other distributions"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        print_success "Kali Linux detected"
    fi
}

update_system() {
    print_status "Updating package lists..."
    apt update -y > /dev/null 2>&1
    print_success "Package lists updated"
}

install_core_tools() {
    print_status "Installing core penetration testing tools..."
    
    local tools=(
        "nmap"                  # Network scanning
        "gobuster"              # Directory/DNS brute forcer
        "nikto"                 # Web vulnerability scanner
        "sqlmap"                # SQL injection tool
        "hydra"                 # Brute force tool
        "whatweb"               # Web technology identifier
        "wfuzz"                 # Web fuzzer
        "dirb"                  # Directory scanner
        "dnsrecon"              # DNS reconnaissance
        "theharvester"          # Information gathering
        "exploitdb"             # Exploit database (includes searchsploit)
        "wafw00f"               # WAF detection
        "sslyze"                # SSL/TLS analyzer
        "curl"                  # HTTP client
        "wget"                  # File downloader
        "dnsutils"              # DNS utilities (includes dig)
        "netcat-traditional"    # Network utility
        "masscan"               # Fast port scanner
        "dmitry"                # Information gathering
        "fierce"                # DNS scanner
        "enum4linux"            # SMB enumeration
        "smbclient"             # SMB client
        "snmp"                  # SNMP tools (includes snmpwalk)
        "onesixtyone"           # SNMP scanner
        "wpscan"                # WordPress scanner
        "joomscan"              # Joomla scanner
        "commix"                # Command injection tester
        "subfinder"             # Subdomain discovery
        "amass"                 # Attack surface mapping
        "assetfinder"           # Subdomain finder
    
    # Burp Suite Community (if not already installed)
        "nuclei"                # Vulnerability scanner
        "ffuf"                  # Web fuzzer
        "john"                  # Password cracker
        "hashcat"               # Password cracker
        "crunch"                # Wordlist generator
        "cewl"                  # Custom wordlist generator
        "medusa"                # Brute force tool
        "patator"               # Multi-purpose brute forcer
        "exploitdb"             # Exploit database
        "metasploit-framework"  # Exploitation framework
    )
    
    local failed_tools=()
    
    for tool in "${tools[@]}"; do
        print_status "Installing $tool..."
        if apt install -y "$tool" > /dev/null 2>&1; then
            print_success "$tool installed successfully"
        else
            print_warning "Failed to install $tool"
            failed_tools+=("$tool")
        fi
    done
    
    if [[ ${#failed_tools[@]} -gt 0 ]]; then
        print_warning "The following tools failed to install:"
        printf '%s\n' "${failed_tools[@]}"
    fi
}

install_python_tools() {
    print_status "Installing Python and pip..."
    apt install -y python3 python3-pip > /dev/null 2>&1
    
    print_status "Installing Python requirements..."
    if [[ -f "requirements.txt" ]]; then
        pip3 install -r requirements.txt > /dev/null 2>&1
        print_success "Python requirements installed"
    else
        print_warning "requirements.txt not found, installing essential packages..."
        pip3 install requests urllib3 lxml beautifulsoup4 python-nmap colorama > /dev/null 2>&1
    fi
}

install_wordlists() {
    print_status "Installing wordlists..."
    
    # SecLists
    if [[ ! -d "/usr/share/seclists" ]]; then
        print_status "Installing SecLists..."
        git clone https://github.com/danielmiessler/SecLists.git /usr/share/seclists > /dev/null 2>&1
        print_success "SecLists installed"
    else
        print_success "SecLists already installed"
    fi
    
    # Common wordlists
    apt install -y wordlists > /dev/null 2>&1
    
    # Dirbuster wordlists
    if [[ ! -d "/usr/share/wordlists/dirbuster" ]]; then
        mkdir -p /usr/share/wordlists/dirbuster
        if [[ -f "/usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt" ]]; then
            cp /usr/share/dirbuster/wordlists/* /usr/share/wordlists/dirbuster/ 2>/dev/null || true
        fi
    fi
}

install_go_tools() {
    print_status "Installing Go-based tools..."
    
    # Install Go if not present
    if ! command -v go &> /dev/null; then
        print_status "Installing Go..."
        apt install -y golang-go > /dev/null 2>&1
    fi
    
    # Install httpx
    if ! command -v httpx &> /dev/null; then
        print_status "Installing httpx..."
        go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest > /dev/null 2>&1
        # Add to PATH
        echo 'export PATH=$PATH:~/go/bin' >> ~/.bashrc
        export PATH=$PATH:~/go/bin
        print_success "httpx installed"
    fi
    
    # Install other Go tools
    local go_tools=(
        "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
        "github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest"
        "github.com/tomnomnom/assetfinder@latest"
        "github.com/ffuf/ffuf@latest"
    )
    
    for tool in "${go_tools[@]}"; do
        tool_name=$(basename "$tool" | cut -d'@' -f1)
        if ! command -v "$tool_name" &> /dev/null; then
            print_status "Installing $tool_name..."
            go install -v "$tool" > /dev/null 2>&1 || print_warning "Failed to install $tool_name"
        fi
    done
}
install_additional_tools() {
    print_status "Installing additional useful tools..."
    
    # Install Go-based tools first
    install_go_tools
    if ! command -v burpsuite &> /dev/null; then
        print_status "Installing Burp Suite Community..."
        apt install -y burpsuite > /dev/null 2>&1
    fi
    
    # OWASP ZAP
    if ! command -v zaproxy &> /dev/null; then
        print_status "Installing OWASP ZAP..."
        apt install -y zaproxy > /dev/null 2>&1
    fi
    
    # Additional reconnaissance tools
    local additional_tools=(
        "sublist3r"
        "recon-ng"
        "maltego"
        "spiderfoot"
        "photon"
    )
    
    for tool in "${additional_tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            print_status "Installing $tool..."
            apt install -y "$tool" > /dev/null 2>&1 || print_warning "Failed to install $tool"
        fi
    done
}

setup_metasploit() {
    print_status "Setting up Metasploit database..."
    
    # Initialize Metasploit database
    if command -v msfdb &> /dev/null; then
        msfdb init > /dev/null 2>&1 || print_warning "Metasploit database initialization failed"
        print_success "Metasploit database initialized"
    fi
}

create_directories() {
    print_status "Creating necessary directories..."
    
    local dirs=(
        "/opt/wordlists"
        "/opt/tools"
        "/opt/scripts"
        "/var/log/pentests"
    )
    
    for dir in "${dirs[@]}"; do
        mkdir -p "$dir"
        chmod 755 "$dir"
    done
    
    print_success "Directories created"
}

configure_tools() {
    print_status "Configuring tools..."
    
    # Update locate database
    updatedb > /dev/null 2>&1 || true
    
    # Update exploitdb
    if command -v searchsploit &> /dev/null; then
        searchsploit -u > /dev/null 2>&1 || print_warning "Failed to update exploitdb"
        print_success "ExploitDB updated"
    fi
    
    # Update Nuclei templates
    if command -v nuclei &> /dev/null; then
        nuclei -update-templates > /dev/null 2>&1 || print_warning "Failed to update Nuclei templates"
        print_success "Nuclei templates updated"
    fi
}

verify_installation() {
    print_status "Verifying tool installation..."
    
    local critical_tools=(
        "nmap"
        "gobuster"
        "nikto"
        "sqlmap"
        "hydra"
        "whatweb"
        "python3"
        "curl"
    )
    
    local missing_tools=()
    
    for tool in "${critical_tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done
    
    if [[ ${#missing_tools[@]} -eq 0 ]]; then
        print_success "All critical tools are installed and available"
    else
        print_error "The following critical tools are missing:"
        printf '%s\n' "${missing_tools[@]}"
        return 1
    fi
}

cleanup() {
    print_status "Cleaning up..."
    apt autoremove -y > /dev/null 2>&1
    apt autoclean > /dev/null 2>&1
    print_success "Cleanup completed"
}

main() {
    print_banner
    
    print_status "Starting WebPenTest Framework tool installation..."
    
    # Pre-installation checks
    check_root
    check_kali
    
    # Installation steps
    update_system
    install_core_tools
    install_python_tools
    install_wordlists
    install_additional_tools
    setup_metasploit
    create_directories
    configure_tools
    
    # Post-installation
    if verify_installation; then
        cleanup
        
        print_success "Installation completed successfully!"
        echo
        print_status "Next steps:"
        echo "1. Run: python3 webpentest.py --help"
        echo "2. Example usage: python3 webpentest.py -t https://example.com"
        echo "3. Make sure to run as root for full functionality"
        echo
        print_warning "Remember: Only use this tool on systems you own or have explicit permission to test!"
    else
        print_error "Installation completed with errors. Some tools may not function properly."
        exit 1
    fi
}

# Script execution
main "$@"
