from ai.brain import arithmetic, logic, creativity, entropy, sanitation
MODULES=[arithmetic, logic, creativity, entropy, sanitation]
def think(text):
    results=[]
    for m in MODULES:
        r = m.process(text)
        if r:
            results.append(r)
    if not results:
        return "I am processing...", []
    winner = max(results, key=lambda x: x["confidence"])
    return winner["output"], results
