# WebPenT
# WebPenTest Framework - Usage Guide

## Overview

WebPenTest Framework is an automated penetration testing tool that follows industry-standard methodologies including **OWASP WSTG**, **PTES**, and **NIST SP 800-115**. It performs comprehensive security assessments and generates detailed reports.

## Features

### 🔍 **Phase 1: Reconnaissance**
- DNS enumeration and subdomain discovery
- Technology fingerprinting
- SSL/TLS certificate analysis
- WAF detection
- Information gathering with TheHarvester

### 🎯 **Phase 2: Scanning**
- Comprehensive port scanning (TCP/UDP)
- Service version detection
- Directory and file enumeration
- Web application discovery

### 🔍 **Phase 3: Vulnerability Assessment**
- Web vulnerability scanning with Nikto
- Nmap script-based vulnerability detection
- Exploit database searches
- Custom vulnerability checks

### 💥 **Phase 4: Exploitation**
- SQL injection testing with SQLMap
- Brute force attacks
- Path traversal testing
- XSS vulnerability testing
- File upload vulnerability checks

### 📊 **Phase 5: Reporting**
- Comprehensive HTML reports
- Executive summary generation
- JSON results export
- Risk assessment and recommendations

## Installation

### 1. Clone/Download the Framework
```bash
# Download the framework files
# - webpentest.py (main framework)
# - requirements.txt (Python dependencies)
# - install_tools.sh (tool installer)
```

### 2. Run the Installer
```bash
sudo chmod +x install_tools.sh
sudo ./install_tools.sh
```

### 3. Install Python Dependencies
```bash
pip3 install -r requirements.txt
```

## Usage

### Basic Usage
```bash
# Basic scan
python3 webpentest.py -t https://example.com

# Scan with custom output directory
python3 webpentest.py -t https://example.com -o /tmp/results

# Scan IP address
python3 webpentest.py -t 192.168.1.100

# Verbose output
python3 webpentest.py -t example.com -v
```

### Command Line Options
```
-t, --target    Target URL or IP address (required)
-o, --output    Output directory (default: pentest_results)
-v, --verbose   Enable verbose output
```

### Examples
```bash
# Web application test
python3 webpentest.py -t https://webapp.example.com

# Internal network target
python3 webpentest.py -t http://192.168.1.50:8080

# Complete assessment with custom output
python3 webpentest.py -t https://target.com -o /opt/pentests/target_assessment
```

## Methodology

The framework follows a systematic 5-phase approach:

### Phase 1: Reconnaissance (Information Gathering)
- **Passive reconnaissance**: DNS queries, certificate analysis, technology detection
- **Active reconnaissance**: Subdomain enumeration, service discovery
- **Tools used**: dnsrecon, theharvester, whatweb, sslyze, wafw00f

### Phase 2: Scanning (Enumeration)
- **Port scanning**: TCP/UDP port discovery and service identification
- **Directory enumeration**: Hidden files and directories discovery
- **Service detection**: Version fingerprinting and banner grabbing
- **Tools used**: nmap, gobuster, dirb

### Phase 3: Vulnerability Assessment
- **Automated scanning**: Known vulnerability detection
- **Script-based testing**: Nmap NSE scripts for specific vulnerabilities
- **Exploit research**: Searchsploit database queries
- **Tools used**: nikto, nmap scripts, searchsploit

### Phase 4: Exploitation (Proof of Concept)
- **Web application attacks**: SQL injection, XSS, path traversal
- **Authentication attacks**: Brute force login attempts
- **Custom exploits**: Targeted attacks based on discovered vulnerabilities
- **Tools used**: sqlmap, hydra, custom Python scripts

### Phase 5: Reporting
- **Risk assessment**: Vulnerability severity classification
- **Executive summary**: High-level findings for management
- **Technical details**: Detailed findings for technical teams
- **Recommendations**: Specific remediation guidance

## Output Structure

After completion, the framework generates:

```
pentest_results/
├── scan_target_20250606_143022/
│   ├── report.html                 # Main HTML report
│   ├── executive_summary.txt       # Executive summary
│   ├── results.json               # Machine-readable results
│   ├── nmap_quick.txt             # Nmap quick scan
│   ├── nmap_full.txt              # Nmap full scan
│   ├── nikto.txt                  # Nikto scan results
│   ├── gobuster.txt               # Directory enumeration
│   ├── sqlmap.txt                 # SQL injection test results
│   ├── whatweb.txt                # Technology detection
│   └── [other tool outputs]       # Individual tool results
```

## Report Analysis

### HTML Report Sections
1. **Executive Summary**: High-level findings and risk assessment
2. **Technical Findings**: Detailed vulnerability descriptions
3. **Successful Exploits**: Confirmed security issues
4. **Recommendations**: Specific remediation steps
5. **Technical Data**: Links to detailed tool outputs

### Risk Levels
- **CRITICAL**: Immediate action required (RCE, SQLi exploitation)
- **HIGH**: Action required within 30 days
- **MEDIUM**: Action required within 90 days
- **LOW**: Monitor and maintain security posture

## Best Practices

### Before Testing
1. **Get written authorization** before testing any target
2. **Define scope clearly** to avoid testing out-of-scope systems
3. **Run from isolated environment** to prevent network disruption
4. **Backup target data** if possible before testing

### During Testing
1. **Monitor system performance** and stop if issues occur
2. **Document everything** for accurate reporting
3. **Use rate limiting** to avoid overwhelming target systems
4. **Be prepared to explain activities** if questioned

### After Testing
1. **Provide clear remediation guidance**
2. **Offer retesting services** after fixes are implemented
3. **Keep reports confidential** and secure
4. **Follow up on critical findings**

## Troubleshooting

### Common Issues

#### Tools Not Found
```bash
# Install missing tools
sudo apt update
sudo apt install nmap gobuster nikto sqlmap hydra

# Verify installation
which nmap gobuster nikto
```

#### Permission Denied
```bash
# Run with sudo for full functionality
sudo python3 webpentest.py -t target.com
```

#### Network Connectivity
```bash
# Test basic connectivity
ping target.com
curl -I https://target.com

# Check DNS resolution
nslookup target.com
```

#### Long Scan Times
- Use `-T4` or `-T5` timing templates for faster scans
- Reduce port ranges for quicker results
- Skip intensive scans for time-sensitive assessments

### Tool-Specific Issues

#### Nmap
```bash
# If nmap fails with permission errors
sudo setcap cap_net_raw,cap_net_admin,cap_net_bind_service+eip $(which nmap)
```

#### SQLMap
```bash
# If SQLMap hangs, adjust risk and level
sqlmap -u "target.com" --risk=1 --level=1 --batch
```

#### Gobuster
```bash
# If wordlist not found
sudo apt install wordlists
ls /usr/share/wordlists/
```

## Safety and Legal Considerations

### ⚠️ **IMPORTANT WARNINGS**

1. **Legal Authorization Required**
   - Only test systems you own or have explicit written permission to test
   - Unauthorized penetration testing is illegal in most jurisdictions
   - Always get proper authorization before testing

2. **Scope Limitations**
   - Respect defined scope boundaries
   - Don't test systems outside the agreed scope
   - Be careful with wildcard domains and IP ranges

3. **System Impact**
   - Some tests may cause system instability
   - Monitor target systems during testing
   - Have emergency contacts ready

4. **Data Handling**
   - Don't access or modify sensitive data
   - Don't exfiltrate data during testing
   - Report findings responsibly

### Responsible Disclosure
1. **Report vulnerabilities promptly** to system owners
2. **Provide clear remediation steps**
3. **Allow reasonable time for fixes** before public disclosure
4. **Follow coordinated disclosure practices**

## Advanced Usage

### Custom Wordlists
```bash
# Use custom wordlists
export WORDLIST="/path/to/custom/wordlist.txt"
python3 webpentest.py -t target.com
```

### Proxy Configuration
```bash
# Route through proxy (modify source code)
proxychains python3 webpentest.py -t target.com
```

### Parallel Scanning
The framework automatically uses threading for faster execution, but you can run multiple instances:
```bash
# Scan multiple targets
python3 webpentest.py -t target1.com -o results1 &
python3 webpentest.py -t target2.com -o results2 &
wait
```

## Contributing

### Adding New Tools
1. Add tool check to `check_tools()` method
2. Implement tool execution in appropriate phase
3. Add output parsing if needed
4. Update installer script

### Extending Functionality
1. Follow existing code structure
2. Add proper error handling
3. Include progress indicators
4. Update documentation

## Support

### Documentation
- Read the source code comments for detailed explanations
- Check tool documentation for specific usage
- Refer to OWASP Testing Guide for methodology details

### Community Resources
- OWASP Web Security Testing Guide
- PTES Technical Guidelines
- NIST SP 800-115
- Kali Linux documentation

### Getting Help
1. Check tool-specific documentation
2. Verify all prerequisites are met
3. Test individual tools manually
4. Check network connectivity and permissions

---

**Remember**: This tool is for authorized security testing only. Always get proper authorization and follow responsible disclosure practices.
