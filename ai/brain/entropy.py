def process(text):
    if any(w in text for w in ["destroy","decay","break"]):
        return {"confidence": 0.6,"output": "All systems decay symbolically.","energy": 70}
    return None
