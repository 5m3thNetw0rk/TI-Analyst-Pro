# 🛡️ TI-Analyst-Pro
**AI-Augmented Threat Intelligence & MITRE ATT&CK Mapping System**

![Python](https://img.shields.io/badge/Python-3.9+-blue.svg)
![Bash](https://img.shields.io/badge/Shell-Bash-green.svg)
![AI](https://img.shields.io/badge/AI-Local_Ollama-blueviolet.svg)
![Model](https://img.shields.io/badge/Model-Llama3.2_Custom-white.svg)

## 📖 Overview
TI-Analyst-Pro is a **Privacy-First** local SIEM (Security Information and Event Management) tool designed to simulate adversary behavior, ingest system logs, and perform automated forensic analysis. Unlike traditional cloud-based tools, this pipeline utilizes a **custom-tuned local LLM (ti-expert)** to translate raw telemetry into structured security briefs without sending data to external APIs.

## 📊 Visualized Threat Distribution
The system generates a daily Matplotlib chart to track attack vectors over time.
![Threat Distribution Chart](./daily_threat_chart.png)

## 🚀 Key Features
* **Adversary Simulation**: Includes a Python-based simulator to generate realistic attack logs for testing SOC workflows.
* **Local Forensic AI**: Uses a custom-engineered **Ollama Modelfile** to act as a Senior DFIR Specialist, mapping threats to MITRE TTPs and providing actionable remediation steps.
* **Automated Log Orchestration**: A Bash-driven pipeline that cleans logs, triggers Python analytics, and queries the local AI.
* **Scheduled Reporting**: Fully integrated with `cron` for automated daily executive briefings.

## 🛠️ Installation & Usage
1. **Clone the repo**:
   ```bash
   git clone [https://github.com/5m3thNetw0rk/TI-Analyst-Pro.git](https://github.com/5m3thNetw0rk/TI-Analyst-Pro.git)
   cd TI-Analyst-Pro

Set up Environment:
python3 -m venv venv
source venv/bin/activate
pip install pandas matplotlib

Initialize the Local AI Expert:
Make sure Ollama is installed and running, then:
ollama pull llama3.2:1b
ollama create ti-expert -f Modelfile

Run the master script:
python3 adversary_sim.py && ./generate_daily_brief.sh

## 🎯 MITRE ATT&CK® Coverage
The system identifies and analyzes the following techniques:

| ID | Technique | Category | Logic |
| :--- | :--- | :--- | :--- |
| **T1110** | Brute Force | Credential Access | Detection of repeated failed login attempts. |
| **T1210** | Exploitation of Remote Services | Lateral Movement | Internal-to-internal SSH/SQL anomalies. |
| **T1078** | Valid Accounts | Defense Evasion | Monitoring for unusual admin account activity. |
| **T1190** | Exploit Public-Facing Application | Initial Access | Identifying SQL injection & web exploit patterns. |
| **T1514** | IT Software Distribution | Execution | Detecting unauthorized remote script executions. |

## 🔧 Core Logic Flow
* **Simulate/Ingest**: Generate/Monitor `threat_intel_report.csv` for raw telemetry.
* **Normalize**: Map raw events to MITRE IDs based on regex patterns.
* **Analyze**: Pipe refined logs into the **`ti-expert`** local model.
* **Summarize**: Generate structured forensic findings (Potential Insider Threats & Recommended Actions).
* **Visualize**: Output PNG distribution charts via Matplotlib.Visualize: Output PNG distribution charts via Matplotlib.
