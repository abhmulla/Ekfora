# Ekfora

Hello! This is a project in the works...

> A modular device-to-server computation offloading framework with multi-device support.

Ekfora (ἐκφορά — "offloading" in Ancient Greek) is a research-driven project aimed at building a flexible, real-time pipeline that offloads heavy computation (like deep learning inference) from edge devices to more capable servers, **across phones, laptops, drones, and sensors**.

We’re entering a world where smart cameras, wearables, and edge agents are everywhere—but not all of them can run YOLO or Whisper on-device. Ekfora is designed to make **seamless, low-latency offloading** of vision and sensor tasks simple, fast, and extensible.

---

### Phase 1 
- Offload live camera feed from an iPhone to a laptop over Wi-Fi.
- Run **YOLOv11 object detection** on the laptop.
- Send back bounding boxes and **visualize the result** either on the laptop or phone.
- Focused on measurable metrics: **latency, FPS, battery savings**.

> This README corresponds to **Phase 1 work**.

---

## Why This Matters

There’s growing demand for:
- Offloading large models from power-limited edge devices.
- Creating mesh-like sensor networks with centralized or hybrid computation.
- Lightweight SDKs that **just work** across platforms.

Ekfora is a step toward a real-time, developer-friendly platform that bridges the edge-to-cloud gap for smart computation.

---

## Technologies Used

| Role | Technology |
|------|------------|
| Client (iOS) | Swift + SwiftUI, AVFoundation, WebSockets |
| Server | Python 3.11, FastAPI, WebSockets, OpenCV |
| Inference | YOLOv8 (Ultralytics), NumPy |
| Transport | WebSocket (Wi-Fi) for image + metadata |
| Codec | JPEG encoding (simple, efficient for early testing) |
| Visualization | OpenCV (laptop), SwiftUI Canvas (planned) |

> Future expansions will explore hardware H.264 encoding, WebRTC, and gRPC/Protobuf protocols.