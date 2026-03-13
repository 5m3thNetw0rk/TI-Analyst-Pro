#!/bin/bash
cd /Users/mattsmethurst/Developer/TI-Analyst-Pro
source venv/bin/activate
python3 adversary_sim.py
./generate_daily_brief.sh
deactivate
