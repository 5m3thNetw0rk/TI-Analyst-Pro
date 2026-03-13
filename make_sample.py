import matplotlib.pyplot as plt

# Dummy Data for the Placeholder
labels = ['Phishing', 'Brute Force', 'Lateral Movement', 'Data Exfiltration']
sizes = [40, 25, 20, 15]
colors = ['#ff9999','#66b3ff','#99ff99','#ffcc99']

plt.figure(figsize=(8, 6))
plt.pie(sizes, labels=labels, colors=colors, autopct='%1.1f%%', startangle=140)
plt.title("Sample Threat Distribution (Operational Summary)")
plt.axis('equal') 

# Save it to a new location for GitHub
plt.savefig('sample_threat_chart.png')
print("✅ Created sample_threat_chart.png")
