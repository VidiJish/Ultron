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
