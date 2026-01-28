import json
from rich.prompt import Prompt
from ai.offline_brain import OfflineBrain
from ai.online_brain import ask
from tools.movies import talk

cfg = json.load(open("config/config.json"))
brain = OfflineBrain(cfg["profile"])

def chat():
    print("SIM LIFE REFLECTION CHAT — type 'exit' to leave")
    while True:
        u = input("You: ").strip()
        if u.lower() == "exit":
            break
        if "movie" in u:
            print("Sim:", talk(u.split()[-1]))
            continue
        if cfg["mode"] == "online" and cfg["openrouter_key"]:
            try:
                print("Sim:", ask(u, cfg))
                continue
            except:
                cfg["mode"] = "offline"
                json.dump(cfg, open("config/config.json", "w"))
        print("Sim:", brain.reply(u.lower()))

while True:
    print("\nSIM LIFE REFLECTION")
    print("1. Chat")
    print("2. Change profile")
    print("3. Toggle online/offline")
    print("4. Set API key / model")
    print("5. Quit")

    c = Prompt.ask(">")

    if c == "1":
        chat()
    elif c == "2":
        cfg["profile"] = Prompt.ask("Choose profile: angel / human / demon / god / trickster / philosopher / alien / cyber-god")
        json.dump(cfg, open("config/config.json", "w"))
        brain = OfflineBrain(cfg["profile"])
    elif c == "3":
        cfg["mode"] = "online" if cfg["mode"] == "offline" else "offline"
        json.dump(cfg, open("config/config.json", "w"))
        print("Mode:", cfg["mode"])
    elif c == "4":
        cfg["openrouter_key"] = Prompt.ask("OpenRouter API key")
        cfg["model"] = Prompt.ask("Model ID")
        cfg["max_tokens"] = int(Prompt.ask("Max tokens", default=str(cfg["max_tokens"])))
        json.dump(cfg, open("config/config.json", "w"))
    elif c == "5":
        print("Sim: Session ended.")
        break
