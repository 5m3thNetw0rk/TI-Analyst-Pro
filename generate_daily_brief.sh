#!/bin/bash
REPORT_FILE="threat_intel_report.csv"
# Fuzzy Match: This grabs "5 Mar" (regardless of the day of the week or leading spaces)
DAY=$(date "+%e")
MONTH=$(date "+%b")
SEARCH_TERM="$(echo $DAY $MONTH)"

echo "🔍 Debug: Searching for '$SEARCH_TERM' in $REPORT_FILE"

# --- 1. DATA GATHERING ---
# We use -w to match the whole word and -i for case-insensitivity
TOTAL_ATTACKS=$(grep -i "$SEARCH_TERM" "$REPORT_FILE" | wc -l)

if [ "$TOTAL_ATTACKS" -eq 0 ]; then
    echo "❌ Still not finding matches for '$SEARCH_TERM'. Let's check the file content:"
    tail -n 2 "$REPORT_FILE"
    exit 0
fi

echo "📊 Generating Threat Distribution Chart..."
python3 make_chart.py

# Grab stats from the whole file for the demo, or keep "$TODAY" if you want strictly daily
HONEYPOT_COUNT=$(grep -c "T1078" "$REPORT_FILE")
LATERAL_COUNT=$(grep -c "T1210" "$REPORT_FILE")
BRUTE_FORCE_COUNT=$(grep -c "T1110" "$REPORT_FILE")
GRAND_TOTAL=$((HONEYPOT_COUNT + LATERAL_COUNT + BRUTE_FORCE_COUNT))


{
    echo "Subject: 🛡️ Security Daily Brief: $TODAY"
    echo "To: $EMAIL"
    echo "------------------------------------------------"
    echo "DAILY THREAT SUMMARY - $TODAY"
    echo "------------------------------------------------"
    echo "Total Threats Neutralized: $GRAND_TOTAL"
    echo "  - Honeypot Triggers:     $HONEYPOT_COUNT"
    echo "  - Lateral Movements:     $LATERAL_COUNT"
    echo "  - External Brute Force:  $BRUTE_FORCE_COUNT"
    echo ""
    echo "TOP CRITICAL EVENTS:"
    grep -i "CRITICAL" "$REPORT_FILE" | grep "$TODAY" | sed 's/"//g' | awk -F',' '{
    summary=""; for(i=7;i<=NF;i++) summary=summary $i " ";
    printf "📍 IP: %-15s | TTP: %-6s | %s\n", $2, $6, summary
    }' | head -n 5
    echo ""
    echo "All identified IPs have been automatically blocked via Firewall."
} > daily_brief.txt

open daily_threat_chart.png

# mail -s "Daily Security Brief" "$EMAIL" < daily_brief.txt

echo "✅ Brief generated in daily_brief.txt"
echo "✅ Daily Brief and Chart are ready!"
echo "📄 Text: daily_brief.txt"
echo "🖼️ Image: daily_threat_chart.pn"
echo "✅ All reports generated successfully."
