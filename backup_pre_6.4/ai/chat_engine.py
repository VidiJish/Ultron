import random
from ai.memory import ShortTermMemory

memory = ShortTermMemory()

BASE_RESPONSES = [
    "Tell me more.",
    "What makes that stand out?",
    "Why that image?",
    "Say it differently.",
    "What do you think it means?",
    "That feels unfinished."
]

LOOP_BREAKERS = [
    "We’re circling. Change direction.",
    "Let’s step sideways for a moment.",
    "This pattern is repeating.",
    "Try a longer thought."
]

def generate_response(user_input):
    memory.add("user", user_input)

    recent = memory.recent()
    entropy = memory.entropy()

    # Detect repetition
    if len(recent) >= 4:
        last_user_inputs = [t for s, t in recent if s == "user"]
        if len(set(last_user_inputs[-3:])) == 1:
            response = random.choice(LOOP_BREAKERS)
        else:
            response = random.choice(BASE_RESPONSES)
    else:
        response = random.choice(BASE_RESPONSES)

    memory.add("sim", response)
    return response
