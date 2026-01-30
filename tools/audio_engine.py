import os
import subprocess

AUDIO_ENABLED = True

def play_audio(file_path):
    if not AUDIO_ENABLED:
        return

    if isinstance(file_path, str) and os.path.exists(file_path):
        try:
            subprocess.run(
                ["termux-media-player", "play", file_path],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL
            )
        except Exception:
            pass

