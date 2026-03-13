import subprocess
import sys

def ask_expert(query):
    # This pipes your question directly into your local Ollama model
    process = subprocess.Popen(
        ['ollama', 'run', 'ti-expert', query],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )
    
    print("\n🛡️ [TI-Expert Analysis]:")
    for line in process.stdout:
        print(line, end='', flush=True)

def main():
    print("--- TI-Analyst-Pro: Incident Response Terminal ---")
    print("Type 'exit' to quit. Ask about suspicious IPs, MITRE TTPs, or logs.")
    
    while True:
        user_input = input("\n👤 [Investigator]: ")
        if user_input.lower() in ['exit', 'quit']:
            break
        
        ask_expert(user_input)

if __name__ == "__main__":
    main()
