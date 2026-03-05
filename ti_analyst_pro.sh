#!/bin/bash
# ==============================================================================
# TI ANALYST PRO: HYBRID INTELLIGENCE EDITION (LOGIC + AI)
# ==============================================================================

# --- 1. CONFIGURATION ---
LOG_FILE="/var/log/threats.log"
INTEL_REPORT_CSV="threat_intel_report.csv"
MODEL="llama3.2"
API_URL="http://localhost:11434/api/generate"
ABUSEIPDB_KEY="e16b14ce213fd148ceb3a703247a9b31c780f08b4f8f7a2d709b415790cf1f773309af5bd61ce092"

# --- 2. SETTINGS ---
HONEY_USERS=("guest_user" "finance_admin" "ceo_private" "backup_service")
GEO_BLOCK_LIST=("CN" "RU" "IR" "KP")
MY_IP=$(ipconfig getifaddr en0 || ipconfig getifaddr en1)
WHITELIST=("127.0.0.1" "$MY_IP" "192.168.1.1")

# --- 3. PRE-FLIGHT ---
if [[ $EUID -ne 0 ]]; then echo "❌ Run as sudo"; exit 1; fi
[ ! -f "$INTEL_REPORT_CSV" ] && echo "Timestamp,IP,Country,Score,Risk,TTP_ID,Summary" > "$INTEL_REPORT_CSV"
pfctl -E > /dev/null 2>&1
trap "echo 'Shutting down...'; exit" SIGINT SIGTERM

echo "------------------------------------------------------------------"
echo "🛡️  TI ANALYST PRO: [HYBRID LOGIC ACTIVE]"
echo "------------------------------------------------------------------"

# --- 4. MAIN LOOP ---
tail -F "$LOG_FILE" | while read -r LINE; do
    [[ -z "$LINE" ]] && continue
    IP=$(echo "$LINE" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -1)
    
    if [[ -n "$IP" ]]; then
        # Whitelist Check
        for SAFE in "${WHITELIST[@]}"; do [[ "$IP" == "$SAFE" ]] && continue 2; done

        # A. Network & Geo Enrichment
        if [[ "$IP" =~ ^192\.168\. ]] || [[ "$IP" =~ ^10\. ]]; then
            ZONE="INTERNAL"; COUNTRY="INTL"; SCORE="0"
        else
            ZONE="EXTERNAL"
            TI_DATA=$(curl -s -G https://api.abuseipdb.com/api/v2/check --data-urlencode "ipAddress=$IP" -H "Key: $ABUSEIPDB_KEY" -H "Accept: application/json")
            SCORE=$(echo "$TI_DATA" | jq -r '.data.abuseConfidenceScore // 0')
            COUNTRY=$(echo "$TI_DATA" | jq -r '.data.countryCode // "XX"')
        fi

        # B. Deterministic Logic (The "Brain")
        IS_HONEYPOT=false
        for USER in "${HONEY_USERS[@]}"; do [[ "$LINE" == *"$USER"* ]] && IS_HONEYPOT=true; done
        
        if [[ "$IS_HONEYPOT" == true ]]; then
            TTP="T1078"; RISK="CRITICAL"; TYPE="Honeypot Trigger"
        elif [[ "$ZONE" == "INTERNAL" ]]; then
            TTP="T1210"; RISK="CRITICAL"; TYPE="Lateral Movement"
        else
            TTP="T1110"; RISK="HIGH"; TYPE="External Brute Force"
        fi

        # C. AI Augmented Summary
        PROMPT="Summarize this in 1 short sentence for a security report: A $TYPE ($TTP) was detected from $IP in $COUNTRY. Log: $LINE"
        
        JSON_PAYLOAD=$(jq -n --arg model "$MODEL" --arg prompt "$PROMPT" '{model: $model, prompt: $prompt, stream: false, options: {temperature: 0.3}}')
        
        SUMM=$(curl -s -X POST "$API_URL" -d "$JSON_PAYLOAD" | jq -r '.response' | tr -d '"')

        # D. Response
        echo "🚨 [$RISK] $TTP: $SUMM"
        echo "$(date),$IP,$COUNTRY,$SCORE,$RISK,$TTP,\"$SUMM\"" >> "$INTEL_REPORT_CSV"
        
        pfctl -t blocked_ips -T add "$IP" > /dev/null 2>&1
        say "Alert. $TYPE detected." &
        echo "------------------------------------------------------------------"
    fi
done
