import websockets
import asyncio
import cv2
import numpy as np
from ultralytics import YOLO

PORT = 7890

print("Server listening to port " + str(PORT))

model = YOLO("yolo11x.pt")

def predict(chosen_model, img, classes=[], conf=0.5):
    if classes:
        results = chosen_model.predict(img, classes=classes, conf=conf)
    else:
        results = chosen_model.predict(img, conf=conf)

    return results

def predict_and_detect(chosen_model, img, classes=[], conf=0.5, rectangle_thickness=2, text_thickness=1):
    results = predict(chosen_model, img, classes, conf=conf)
    for result in results:
        for box in result.boxes:
            cv2.rectangle(img, (int(box.xyxy[0][0]), int(box.xyxy[0][1])),
                          (int(box.xyxy[0][2]), int(box.xyxy[0][3])), (255, 0, 0), rectangle_thickness)
            cv2.putText(img, f"{result.names[int(box.cls[0])]}",
                        (int(box.xyxy[0][0]), int(box.xyxy[0][1]) - 10),
                        cv2.FONT_HERSHEY_PLAIN, 1, (255, 0, 0), text_thickness)
    return img, results

async def echo(websocket):
    print("Client connected")
    async for message in websocket:
        print("Message received from client")
        
        message = np.frombuffer(message, dtype=np.uint8)

        # Decode JPEG image to OpenCV format
        frame = cv2.imdecode(message, cv2.IMREAD_COLOR)

        if frame is None:
            continue

        result_img, _ = predict_and_detect(model, frame, classes=[], conf=0.5)  

        cv2.imshow("Live Stream", result_img)

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