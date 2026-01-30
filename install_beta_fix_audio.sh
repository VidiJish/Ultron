#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "🔧 SLR Beta 1.1 – Audio Fix & Rewrite"

# Paths
SLR_DIR="$HOME/SLR"
BACKUP_DIR="$SLR_DIR/backup_audio_code"
VENV="$SLR_DIR/venv"

cd "$SLR_DIR"

echo "📦 Creating backup of Python files..."
mkdir -p "$BACKUP_DIR"
find . -name "*.py" -exec cp {} "$BACKUP_DIR/" \;

echo "🧹 Removing playsound references..."
find . -name "*.py" -exec sed -i 's/from playsound import playsound/# playsound removed/g' {} \;
find . -name "*.py" -exec sed -i 's/playsound(/play_audio(/g' {} \;

echo "🔊 Installing audio dependencies..."
pkg install -y mpg123
source "$VENV/bin/activate"
pip uninstall -y playsound || true
pip install pyttsx3

echo "🧠 Injecting unified audio engine..."
cat > tools/audio_engine.py << 'EOF'
import os
import subprocess
import pyttsx3

engine = pyttsx3.init()

def play_audio(input_data):
    if isinstance(input_data, str) and input_data.endswith(".mp3") and os.path.exists(input_data):
        subprocess.run(["mpg123", input_data], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    else:
        engine.say(str(input_data))
        engine.runAndWait()
EOF

echo "🔗 Linking audio engine into codebase..."
find . -name "*.py" -exec sed -i '1s|^|from tools.audio_engine import play_audio\n|' {} \;

echo "✅ Audio rewrite complete"
echo "▶ Test with: python main.py"
