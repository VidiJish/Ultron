#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "🚀 Installing SLR 6.6..."

BASE_DIR="$HOME/SLR"

cd "$BASE_DIR"

# Ensure venv
if [ ! -d "venv" ]; then
  python -m venv venv
fi

source venv/bin/activate

pip install --upgrade pip
pip install rich simpleaudio pyttsx3

echo "🧠 Creating brain modules..."

mkdir -p ai/brain
touch ai/brain/__init__.py

#################################
# Arithmetic Brain
#################################
cat > ai/brain/arithmetic.py << 'EOF'
import re

def solve_expression(text):
    try:
        expr = re.findall(r"[0-9+\-*/(). ]+", text)
        if not expr:
            return None
        result = eval(expr[0], {"__builtins__": {}})
        return f"The answer is {result}"
    except Exception:
        return None
EOF

#################################
# Logic Brain
#################################
cat > ai/brain/logic.py << 'EOF'
def evaluate_logic(text):
    text = text.lower()
    if "and" in text:
        return "Both conditions must be true."
    if "or" in text:
        return "Only one condition must be true."
    if "not" in text:
        return "This negates the condition."
    return None
EOF

#################################
# Creativity Brain
#################################
cat > ai/brain/creativity.py << 'EOF'
import random

IDEAS = [
    "A story about a machine learning empathy.",
    "A game where memory changes reality.",
    "A city powered by forgotten thoughts."
]

def generate_idea(_):
    return random.choice(IDEAS)
EOF

#################################
# Sanitation / Waste (SAFE)
#################################
cat > ai/brain/sanitation.py << 'EOF'
def sanitation_tips(_):
    return (
        "Waste management involves separation, containment, and disposal "
        "according to environmental and safety regulations."
    )
EOF

#################################
# Audio Brain
#################################
mkdir -p tools

cat > tools/audio_brain.py << 'EOF'
import pyttsx3

_engine = None

def speak(text):
    global _engine
    if _engine is None:
        _engine = pyttsx3.init()
    _engine.say(text)
    _engine.runAndWait()
EOF

#################################
# Chat Engine Upgrade
#################################
cat > ai/chat_engine.py << 'EOF'
from ai.brain.arithmetic import solve_expression
from ai.brain.logic import evaluate_logic
from ai.brain.creativity import generate_idea
from ai.brain.sanitation import sanitation_tips

def generate_response(user_input):
    for module in (
        solve_expression,
        evaluate_logic,
        generate_idea,
        sanitation_tips,
    ):
        reply = module(user_input)
        if reply:
            return reply
    return "Can you explain that a bit more?"
EOF

#################################
# Main loop patch
#################################
cat > main.py << 'EOF'
from ai.chat_engine import generate_response
from tools.audio_brain import speak

def chat():
    print("SIM LIFE REFLECTION CHAT — type 'exit' to leave")
    while True:
        user_input = input("You: ").strip()
        if user_input.lower() == "exit":
            print("Sim: Session ended.")
            break
        reply = generate_response(user_input)
        print(f"Sim: {reply}")
        speak(reply)

if __name__ == "__main__":
    chat()
EOF

#################################
# GitHub Push
#################################
if [ -d ".git" ]; then
  git add .
  git commit -m "SLR 6.6 – modular brain, logic, arithmetic, audio sync"
  git push
else
  echo "⚠️ Not a git repo. Run:"
  echo "git init && git remote add origin <YOUR_REPO_URL>"
fi

echo "✅ SLR 6.6 installed successfully."
