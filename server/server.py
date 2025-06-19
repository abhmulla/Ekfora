import websockets
import asyncio

PORT = 7890

print("Server listening to port " + str(PORT))

async def echo(websocket):
    print("Client connected")
    async for message in websocket:
        print("Message received from client")
        await websocket.send("Pong " + message)

async def main():
    async with websockets.serve(echo, "0.0.0.0", PORT):
        await asyncio.Future()  # Run foreve

if __name__ == "__main__":
    asyncio.run(main())