from collections import deque
import random

class ShortTermMemory:
    def __init__(self, size=6):
        self.buffer = deque(maxlen=size)

    def add(self, speaker, text):
        self.buffer.append((speaker, text))

    def recent(self):
        return list(self.buffer)

    def entropy(self):
        return random.uniform(0.15, 0.45)

# Alias so offline_brain can import Memory
Memory = ShortTermMemory

