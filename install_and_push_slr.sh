#!/data/data/com.termux/files/usr/bin/bash

echo "[*] Starting unified SLR 6.3 Install & GitHub Push"

# --------- Update Termux and install core packages ---------
pkg update -y
pkg upgrade -y
pkg install -y python git cmake clang wget mpg123 imagemagick

# --------- Move to HOME and clone repo if missing ---------
cd $HOME
if [ ! -d "SLR" ]; then
  git clone https://github.com/YOUR_PRIVATE_GITHUB/SLR.git
fi
cd SLR || exit 1

# --------- Python venv setup ---------
python -m venv venv
source venv/bin/activate
pip install --upgrade pip

# --------- Install Python dependencies ---------
pip install tinydb colorama sentence-transformers numpy requests beautifulsoup4 playsound pillow

# --------- Create necessary directories ---------
mkdir -p tournaments collaboration multi_modal reasoning personality/branches personality/fusion models licenses licenses/marketplace licenses/mind_creator licenses/subscriptions backups network/sync revenue/analytics revenue/promotions dashboards memory think_tank/spatial_art think_tank/facial_imaging think_tank/text_interpretation think_tank/experiments

# --------- Add background reader & alias shortcut ---------
grep -q "background_reader" ~/.bashrc || echo "nohup python $HOME/SLR/reader/background_reader.py &" >> ~/.bashrc
grep -q "alias slr" ~/.bashrc || echo "alias slr='cd \$HOME/SLR && source venv/bin/activate && python main.py'" >> ~/.bashrc

# --------- GitHub push ---------
git init 2>/dev/null
git remote add origin https://github.com/YOUR_PRIVATE_GITHUB/SLR.git 2>/dev/null || true
git add .
git commit -m "SLR 6.3 full installation: multi-modal AI, tournaments, collaboration, background AI, think tank"
git branch -M main
echo "[*] Ready to push to GitHub. You will need your GitHub username and Personal Access Token (PAT)."
git push -u origin main

echo "[✓] SLR 6.3 install complete, pushed to GitHub!"
echo "Run: source ~/.bashrc && slr"
