import websockets
import asyncio
import cv2
import numpy as np
from ultralytics import YOLO

PORT = 7890

print("Server listening to port " + str(PORT))

model = YOLO("yolo11x.pt")

async def echo(websocket):
    print("Client connected")
    async for message in websocket:

        message = np.frombuffer(message, dtype=np.uint8)

        # Decode JPEG image to OpenCV format
        frame = cv2.imdecode(message, cv2.IMREAD_COLOR)

        if frame is None:
            continue
        
        results = model.track(source=frame, persist=True, conf=0.5, tracker="bytetrack.yaml")
        annotated_frame = results[0].plot()

        cv2.imshow("Live Stream", annotated_frame)

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