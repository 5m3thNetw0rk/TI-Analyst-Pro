import csv
from datetime import datetime
import random
import os

LOG_FILE = "threat_intel_report.csv"

scenarios = [
    {"IP": "192.168.1.50", "Country": "Internal", "TTP": "T1210", "Summary": "Lateral movement: Unauthorized SSH to Database Server."},
    {"IP": "45.33.22.11", "Country": "China", "TTP": "T1110", "Summary": "Brute force: Multiple failed logins on root account."},
    {"IP": "104.244.42.1", "Country": "Russia", "TTP": "T1190", "Summary": "Exploit: SQL injection attempt on web portal."},
    {"IP": "172.16.0.12", "Country": "Internal", "TTP": "T1078", "Summary": "Credential Abuse: Admin login from unknown MAC address."},
]

def inject_threat():
    event = random.choice(scenarios)
    timestamp = datetime.now().strftime("%e %b") 
    
    row = [timestamp, event["IP"], event["Country"], random.randint(50, 100), "High", event["TTP"], event["Summary"]]
    
    file_exists = os.path.isfile(LOG_FILE)
    with open(LOG_FILE, "a", newline="") as f:
        writer = csv.writer(f)
        if not file_exists:
            writer.writerow(["Timestamp", "IP", "Country", "AbuseScore", "Risk", "TTP", "Summary"])
        writer.writerow(row)
    
    print(f"🚀 Injected Attack: {event['TTP']} from {event['IP']}")

if __name__ == "__main__":
    for _ in range(5):
        inject_threat()
