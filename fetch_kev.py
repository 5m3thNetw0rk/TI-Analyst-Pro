import requests
import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
KB_DIR = os.path.join(BASE_DIR, "knowledge_base")

# The official CISA KEV JSON endpoint
URL = "https://www.cisa.gov/sites/default/files/feeds/known_exploited_vulnerabilities.json"
KB_PATH = "/Users/mattsmethurst/Developer/TI-Analyst-Pro/knowledge_base/cisa_kev_latest.txt"

print("📡 Fetching latest CISA KEV data...")
data = requests.get(URL).json()

with open(KB_PATH, "w") as f:
    f.write("OFFICIAL CISA KEV DATA SUMMARY\n" + "="*30 + "\n")
    for vuln in data['vulnerabilities'][:50]: # Grab the 50 most recent
        f.write(f"CVE: {vuln['cveID']} | Product: {vuln['product']} | Issue: {vuln['shortDescription']}\n")

print(f"✅ Success! 50 most recent 'In the Wild' exploits saved to your KB.")
