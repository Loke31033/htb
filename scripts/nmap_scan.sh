#!/bin/bash

# HTB Meow Machine - Automated Reconnaissance Script
# Author: Lokeshwar
# Date: January 29, 2026

echo "=========================================="
echo "HTB Meow Machine Reconnaissance Script"
echo "=========================================="

# Configuration
TARGET_IP="10.129.64.121"
OUTPUT_DIR="../evidence"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Create output directory
mkdir -p $OUTPUT_DIR

echo "[*] Starting reconnaissance on $TARGET_IP"
echo "[*] Timestamp: $TIMESTAMP"
echo ""

# 1. Quick Ping Check
echo "[1/4] Performing ping check..."
ping -c 3 $TARGET_IP > $OUTPUT_DIR/ping_check_$TIMESTAMP.txt
if [ $? -eq 0 ]; then
    echo "    ✓ Host is reachable"
else
    echo "    ✗ Host is unreachable"
    exit 1
fi

# 2. Quick Port Scan
echo "[2/4] Performing quick port scan..."
sudo nmap -sS -T4 $TARGET_IP > $OUTPUT_DIR/quick_scan_$TIMESTAMP.txt
echo "    ✓ Quick scan completed"

# 3. Detailed Service Scan
echo "[3/4] Performing detailed service scan..."
sudo nmap -sV -sC -O -T4 $TARGET_IP > $OUTPUT_DIR/detailed_scan_$TIMESTAMP.txt
echo "    ✓ Detailed scan completed"

# 4. Full Aggressive Scan
echo "[4/4] Performing aggressive scan..."
sudo nmap -A -T4 $TARGET_IP > $OUTPUT_DIR/aggressive_scan_$TIMESTAMP.txt
echo "    ✓ Aggressive scan completed"

# 5. Generate Summary
echo ""
echo "[*] Generating scan summary..."
echo "=========================================="
echo "SCAN SUMMARY"
echo "=========================================="
echo "Target: $TARGET_IP"
echo "Time: $(date)"
echo "Output Files:"
ls -la $OUTPUT_DIR/*$TIMESTAMP.txt
echo ""
echo "Open Ports Summary:"
grep -E "^[0-9]+/tcp.*open" $OUTPUT_DIR/detailed_scan_$TIMESTAMP.txt

# 6. Check for Telnet
echo ""
echo "[*] Checking for Telnet service..."
if grep -q "23/tcp.*open.*telnet" $OUTPUT_DIR/detailed_scan_$TIMESTAMP.txt; then
    echo "    ⚠️  Telnet service detected on port 23"
    echo "    Recommendation: This is highly insecure!"
else
    echo "    ✓ No Telnet service detected"
fi

echo ""
echo "=========================================="
echo "Reconnaissance completed successfully!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Review scan results in $OUTPUT_DIR/"
echo "2. Check Telnet service: telnet $TARGET_IP"
echo "3. Look for authentication weaknesses"
