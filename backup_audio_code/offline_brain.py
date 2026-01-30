import random
from ai.profiles import PROFILES
from ai.memory import Memory

class OfflineBrain:
    def __init__(self, profile):
        self.profile = profile
        self.memory = Memory()

    def reply(self, user):
        self.memory.add(user)
        p = PROFILES[self.profile]

        if "real" in user:
            return "Reality is experienced, not declared."
        if "alone" in user:
            return "Isolation sharpens awareness."
        if "draw" in user:
            return "/\\\n||\n||__ Structure gives form."
        if "score" in user:
            return f"Social credit is {random.randint(0,100)}%"
        return random.choice(p["idle"])
