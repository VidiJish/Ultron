MOVIES = {
  "matrix": "The Matrix explores simulated reality and control.",
  "interstellar": "Interstellar examines time, love, and survival.",
  "inception": "Inception dives into dreams and layers of consciousness.",
  "thegodfather": "The Godfather examines power, family, and betrayal.",
  "parasite": "Parasite explores class divide and human greed.",
  "avengers": "Avengers assembles heroes to face existential threats.",
  "blade_runner": "Blade Runner questions identity, memory, and what it means to be human.",
  "arrival": "Arrival examines language, time, and communication.",
  "joker": "Joker dissects society, mental health, and chaos.",
  "eternal_sunshine": "Eternal Sunshine explores memory, love, and loss."
}

def talk(name):
    return MOVIES.get(name.lower(), "I know that film. Ask differently.")
