
KB_DIR="/Users/mattsmethurst/Developer/TI-Analyst-Pro/knowledge_base"
mkdir -p "$KB_DIR"
# List of critical security tools to "teach" the AI
TOOLS=("auditctl" "ausearch" "tcpdump" "lsof" "python3" "bash" "chmod" "ls" "grep")

echo "📚 Populating Knowledge Base..."

for tool in "${TOOLS[@]}"; do
    if man "$tool" > /dev/null 2>&1; then
        # Export man page to text, removing formatting gunk
        man "$tool" | col -bx > "$KB_DIR/${tool}_manual.txt"
        echo "✅ Added manual for: $tool"
    else
        echo "❌ Manual for $tool not found."
    fi
done

echo "🚀 KB is ready for RAG!"
