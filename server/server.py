import websockets
import asyncio
import cv2
import numpy as np

PORT = 7890

print("Server listening to port " + str(PORT))

async def echo(websocket):
    print("Client connected")
    async for message in websocket:
        #print("Message received from client")
        
        message = np.frombuffer(message, dtype=np.uint8)

        # Decode JPEG image to OpenCV format
        frame = cv2.imdecode(message, cv2.IMREAD_COLOR)

        if frame is None:
            continue  

        cv2.imshow("Live JPEG Stream", frame)

        # Wait a short time — adjust for desired FPS
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

async def main():
    try:
        async with websockets.serve(echo, "0.0.0.0", PORT):
            await asyncio.Future() 
    except KeyboardInterrupt:
            cv2.destroyAllWindows()


if __name__ == "__main__":
    asyncio.run(main())