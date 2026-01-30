def scan(results):
    print("\n🧠 BRAIN ACTIVITY:")
    for r in results:
        bars=int(r["confidence"]*20)
        print(f"[{'█'*bars:<20}] {int(r['confidence']*100)}% | Energy {r['energy']}")
