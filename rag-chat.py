import os
import subprocess

# --- CONFIGURATION ---
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
KB_DIR = os.path.join(BASE_DIR, "knowledge_base")
MODEL_NAME = "ti-expert"  # Must match your Ollama 'ti-expert' name

def get_relevant_context(user_query):
    """Librarian: Only grabs files matching high-value security terms."""
    context = ""
    
    # 🎯 PRECISION: These keywords 'force' the librarian to look for specific intel
    security_terms = ["apt29", "teams", "microsoft", "onmicrosoft", "phishing", "c2", "malware", "cyber"]
    
    # Clean user query: remove small words (a, i, the) and join with security terms
    query_words = [word.lower().strip(".,?!") for word in user_query.split() if len(word) > 3]
    search_set = set(query_words + security_terms)
    
    print(f"\n🔎 [Librarian]: Searching for high-value targets: {list(search_set)}")
    
    found_files = []
    if not os.path.exists(KB_DIR):
        print(f"❌ Error: Knowledge base directory not found at {KB_DIR}")
        return ""

    for filename in os.listdir(KB_DIR):
        if any(term in filename.lower() for term in search_set):
            found_files.append(filename)
            with open(os.path.join(KB_DIR, filename), 'r') as f:
                context += f"--- SOURCE DOCUMENT: {filename} ---\n"
                context += f.read() + "\n\n"
    
    if found_files:
        print(f"📖 [Librarian]: Found relevant files: {found_files}")
    else:
        print("⚠️ [Librarian]: No specific matches found. Using internal training.")
        
    return context

def ask_expert_with_rag(query):
    context = get_relevant_context(query)
    
    # 🛡️ STRICT PERSONA: Forces the AI to use your files, not generic safety tips.
    prompt = f"""
    ### ROLE:
    You are a Senior Threat Intelligence Analyst. 
    Your ONLY source of truth is the [DOCUMENTATION] provided below.
    
    ### STRICT RULES:
    1. If the [DOCUMENTATION] mentions specific actors (like APT29) or tactics (like Teams phishing), prioritize that.
    2. If the answer is not in the [DOCUMENTATION], say "No local intel found."
    3. DO NOT give generic safety advice or Python coding tutorials.
    
    [DOCUMENTATION]:
    {context}
    
    [USER QUESTION]:
    {query}
    
    [ANALYST RESPONSE]:
    """
    
    process = subprocess.Popen(
        ['ollama', 'run', MODEL_NAME, prompt],
        stdout=subprocess.PIPE, 
        stderr=subprocess.PIPE,
        text=True
    )
    
    print("\n🛡️ [TI-Expert Analysis]:")
    print("-" * 30)
    for line in process.stdout:
        print(line, end='', flush=True)

if __name__ == "__main__":
    print("🕵️ TI-Analyst-Pro RAG System Active (Strict Mode)")
    print("Type 'exit' to quit.")
    
    while True:
        user_input = input("\n👤 [Investigator]: ")
        if user_input.lower() in ['exit', 'quit']:
            break
        ask_expert_with_rag(user_input)
