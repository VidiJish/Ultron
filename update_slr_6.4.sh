#!/data/data/com.termux/files/usr/bin/bash
# SLR 6.4 Update Patch Installer
# Adds context-aware chat, memory fixes, AI improvements

set -e

echo "[*] Starting SLR 6.4 update patch..."

SLR_HOME="$HOME/SLR"
BACKUP_DIR="$SLR_HOME/backup_pre_6.4"

mkdir -p "$BACKUP_DIR"

echo "[*] Backing up old AI modules..."
cp -r "$SLR_HOME/ai" "$BACKUP_DIR/"

echo "[*] Updating chat_engine.py..."
cat > "$SLR_HOME/ai/chat_engine.py" << 'EOF'
from ai.memory import ShortTermMemory
import random

# Initialize memory buffer
memory = ShortTermMemory(size=8)

def generate_response(user_input):
    user_input = user_input.strip()
    memory.add("user", user_input)

    # Keyword-aware responses
    if "image" in user_input.lower():
        return "Images? Describe it more."

    if "hello" in user_input.lower() or "hi" in user_input.lower():
        return "Hello! How are you feeling today?"

    # Contextual memory reference
    recent = memory.recent()
    if recent:
        last_user = recent[-2][1] if len(recent) > 1 else recent[-1][1]
        if last_user.lower() != user_input.lower():
            return f"I remember you said '{last_user}'. Tell me more."

    # Random fallback
    return random.choice([
        "Say it differently.",
        "Why that image?",
        "Truth rarely comforts.",
        "Tell me more."
    ])
EOF

echo "[*] Updating main.py chat function..."
cat > "$SLR_HOME/main.py" << 'EOF'
#!/data/data/com.termux/files/usr/bin/python3
from ai.chat_engine import generate_response

def chat():
    print("SIM LIFE REFLECTION CHAT — type 'exit' to leave")
    while True:
        user_input = input("You: ").strip()
        if user_input.lower() == "exit":
            print("Sim: Session ended.")
            break
        reply = generate_response(user_input)
        print(f"Sim: {reply}")

def main_menu():
    while True:
        print("""
SIM LIFE REFLECTION
1. Chat
2. Change profile
3. Toggle online/offline
4. Set API key / model
5. Quit
""")
        choice = input(">: ").strip()
        if choice == "1":
            chat()
        elif choice == "5":
            print("Sim: Session ended.")
            break
        else:
            print("Sim: Option not implemented yet.")

if __name__ == "__main__":
    main_menu()
EOF

echo "[*] Cleaning old Python caches..."
find "$SLR_HOME" -name "*.pyc" -delete

echo "[✓] SLR 6.4 patch applied successfully!"
echo "[*] Run SLR with: "
echo "    source $SLR_HOME/venv/bin/activate && python $SLR_HOME/main.py"
