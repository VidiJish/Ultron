import json, os
from collections import deque

class Memory:
    def __init__(self, path="data/memory.json", limit=50):
        self.path = path
        self.buffer = deque(maxlen=limit)
        if os.path.exists(path):
            self.buffer.extend(json.load(open(path)))

    def add(self, text):
        self.buffer.append(text)
        json.dump(list(self.buffer), open(self.path, "w"))

    def context(self):
        return list(self.buffer)
