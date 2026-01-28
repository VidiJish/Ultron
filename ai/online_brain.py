import requests, json

def ask(prompt, cfg):
    headers = {
        "Authorization": f"Bearer {cfg['openrouter_key']}",
        "Content-Type": "application/json"
    }

    data = {
        "model": cfg["model"],
        "max_tokens": cfg["max_tokens"],
        "messages": [{"role": "user", "content": prompt}]
    }

    r = requests.post(
        "https://openrouter.ai/api/v1/chat/completions",
        headers=headers,
        json=data,
        timeout=20
    )

    if r.status_code != 200:
        raise RuntimeError("API unavailable")

    return r.json()["choices"][0]["message"]["content"]
