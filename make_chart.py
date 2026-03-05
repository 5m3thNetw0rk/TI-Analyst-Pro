import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('threat_intel_report.csv')

df.columns = df.columns.str.strip()

print(f"📊 Found columns: {list(df.columns)}")

target_col = 'TTP_ID' if 'TTP_ID' in df.columns else 'TTP'

if target_col not in df.columns:
    print(f"❌ Error: Could not find a TTP column. Available: {list(df.columns)}")
else:
    counts = df[target_col].value_counts()
    plt.figure(figsize=(10, 7))
    counts.plot(kind='pie', autopct='%1.1f%%', colors=['#ff9999','#66b3ff','#99ff99','#ffcc99'])
    plt.title('Threat Distribution - TI Analyst Pro')
    plt.ylabel('')
    
    plt.savefig('daily_threat_chart.png')
    print("📈 Success! Chart saved as daily_threat_chart.png")
