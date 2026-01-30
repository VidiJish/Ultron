def evaluate_logic(text):
    text = text.lower()
    if "and" in text:
        return "Both conditions must be true."
    if "or" in text:
        return "Only one condition must be true."
    if "not" in text:
        return "This negates the condition."
    return None
