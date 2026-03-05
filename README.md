# AI-Augmented Threat Intelligence & Response System

A real-time security pipeline that monitors system logs, categorizes threats using **MITRE ATT&CK** TTPs, enriches data via **AbuseIPDB**, and generates AI-driven summaries using **Gemini**.

## 🚀 Features
* **Real-time Log Ingestion**: Monitors `/var/log/threats.log` for suspicious activity.
* **Automated Firewall Action**: Blocks malicious IPs via `pfctl` (macOS).
* **AI Analysis**: Summarizes the "why" behind threats using LLMs.
* **Daily Reporting**: Generates a PDF/PNG report of threat distribution using Python (Pandas/Matplotlib).

## 🛠️ Tech Stack
* **Language**: Bash, Python 3.x
* **AI**: Gemini 1.5 Flash
* **Libraries**: Pandas, Matplotlib
