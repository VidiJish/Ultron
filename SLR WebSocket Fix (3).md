From: <Saved by Blink>
Snapshot-Content-Location: https://chatgpt.com/c/697c8e7f-9e30-8324-ac5d-8b4988dc13ed
Subject: SLR WebSocket Fix
Date: Sat, 31 Jan 2026 12:47:22 +1300
MIME-Version: 1.0
Content-Type: multipart/related;
	type="text/html";
	boundary="----MultipartBoundary--EQhx3W5IC9Ixl854OVrAlT7RtfW9L7zU6w1GJIcWg1----"

------MultipartBoundary--EQhx3W5IC9Ixl854OVrAlT7RtfW9L7zU6w1GJIcWg1----
Content-Type: text/html
Content-ID: <frame-46AA007B646DC4C7687DB9738B0C83FB@mhtml.blink>
Content-Transfer-Encoding: binary
Content-Location: https://chatgpt.com/c/697c8e7f-9e30-8324-ac5d-8b4988dc13ed

<!DOCTYPE html><html lang="en-US" data-build="prod-f79aa7b9c9d64760e9f2ff5348ccf814707a1024" data-seq="4341314" dir="ltr" class="dark" style="color-scheme: dark;" data-chat-theme="default"><head><meta[...] 

Project: SLR (SimLife Reflection)
Repo: https://github.com/VidiJish/Ultron
Environment: Termux (Android), Python 3.12, venv

Current focus: Fix and stabilize WebSocket communication between Android and SLR.

Status:
- WebSocket server runs on ws://0.0.0.0:8765
- Android connects successfully
- Messages are received but:
  - Android client is echoing server responses back
  - Server currently prints raw messages and lacks strict protocol handling
- This causes confusing logs like server responses being re-received as input

Goal:
- Clean WebSocket protocol
- One-way command flow (Android → SLR, SLR → Android response)
- JSON-only message handling
- No echo loops
- Stable long-running server in Termux

Known fixes discussed:
1. Ignore non-JSON messages on server
2. Android must NOT resend server responses
3. Use message structure with origin/type/data
4. Add simple command router (status, chat, safe commands)
5. Disable ping timeout issues (ping_interval=None)

Last working direction:
We were rewriting tools/ws_server.py to properly parse JSON, route commands, and respond cleanly without loops.

Instruction:
“Continue fixing the SLR WebSocket exactly from here.”</div></div></div></div></div><div class="z-0 flex justify-end"><div class="touch:-me-2 touch:-ms-3.5 -ms-2.5 -me-1 flex flex-wrap items-cente[...]
<p data-start="289" data-end="351">Here’s a robust <code data-start="305" data-end="319">ws_server.py</code> you can drop in your project:</p>

<pre>import asyncio
import json
import websockets
from websockets.exceptions import ConnectionClosedOK, ConnectionClosedError

# Server config
HOST = '0.0.0.0'
PORT = 8765

# Connected clients
clients = set()

# Command router
async def handle_command(message, websocket):
    """
    Routes commands from Android to appropriate handlers.
    Expects message as dict with keys: origin, type, data
    """
    msg_type = message.get("type")
    origin = message.get("origin")
    data = message.get("data")

    response = {"origin": "SLR", "type": "error", "data": {"message": "Unknown command"}}

    if msg_type == "status":
        # Simple status check
        response = {"origin": "SLR", "type": "status", "data": {"uptime": "running", "time": "now"}}
    elif msg_type == "chat":
        # Echo chat back as confirmation (but not broadcasting)
        response = {"origin": "SLR", "type": "chat", "data": {"reply": data}}
    elif msg_type == "safe_command":
        # Example safe command handling
        response = {"origin": "SLR", "type": "safe_command", "data": {"result": "executed"}}
    else:
        # Unknown command type
        response = {"origin": "SLR", "type": "error", "data": {"message": "Unknown command type"}}

    await websocket.send(json.dumps(response))

async def handle_client(websocket, path):
    """
    Handle each connected client
    """
    clients.add(websocket)
    print(f"[SLR] Client connected: {websocket.remote_address}")
    try:
        async for raw_message in websocket:
            # Attempt to parse JSON, ignore invalid messages
            try:
                message = json.loads(raw_message)
            except json.JSONDecodeError:
                print(f"[SLR] Received non-JSON message, ignoring: {raw_message}")
                continue

            # Ensure message has 'origin' to prevent echo loops
            if message.get("origin") == "SLR":
                # Skip any messages that originated from the server
                continue

            # Handle command
            await handle_command(message, websocket)

    except (ConnectionClosedOK, ConnectionClosedError):
        print(f"[SLR] Client disconnected: {websocket.remote_address}")
    finally:
        clients.remove(websocket)

async def main():
    print(f"[SLR] Starting WebSocket server on ws://{HOST}:{PORT}")
    async with websockets.serve(handle_client, HOST, PORT, ping_interval=None):
        await asyncio.Future()  # run forever

if __name__ == "__main__":
    asyncio.run(main())
</pre>

<hr>
<h3>✅ Key Improvements</h3>

- JSON-only messages: Non-JSON messages are ignored.
- No echo loops: Messages originating from the server (origin: "SLR") are ignored.
- Command router: handle_command routes status/chat/safe_command.
- Clean logs: Prints only meaningful events (connect/disconnect, non-JSON messages).
- Stable in Termux: ping_interval=None disables automatic ping timeouts.

<hr>
<h3>Example Android → SLR message</h3>

{
  "origin": "Android",
  "type": "status",
  "data": {}
}

Server responds:

{
  "origin": "SLR",
  "type": "status",
  "data": {}
}

Next step I recommend:

- Update your Android client to never resend messages that come from the server.
- Only send messages with origin: "Android" and process responses with origin: "SLR".

If you want, I can also rewrite the Android WebSocket snippet to guarantee it obeys this one-way flow.

<hr>

(Additional android_client.py example and extensive instructions omitted here to keep commit concise — full original content retained in your local copy.)