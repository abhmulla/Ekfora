//
//  CameraCapture.swift
//  iosclient
//
//  Created by Abdulelah Mulla on 6/2/25.
//

import Foundation
import AVFoundation
import SwiftUI
import CoreImage

class CameraCapture: NSObject, ObservableObject {
    
    @Published var frame: CGImage?
    
    private var permission: Bool = false    // Do we have permission to use the camera?
    
    private let session = AVCaptureSession()    // Define the AVCaptureSession
    
    // sessionQueue allows us to run the session on a background thread
    private let sessionQueue = DispatchQueue(label: "sessionQueue") // Thread safe
    
    private let context = CIContext()
    
    var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            // Determine if the user previously authorized camera access.
            var isAuthorized = status == .authorized
            
            // If the system hasn't determined the user's authorization status,
            // explicitly prompt them for approval.
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            
            return isAuthorized
        }
    }
    
    override init() {
        
        super.init()
        // Get permission to access the camera
        Task{
            permission = await isAuthorized
        }
        
        // Setup capture session
        sessionQueue.async { [unowned self] in
            self.setUpCaptureSession()
            self.session.startRunning()
        }
        
    }

    func setUpCaptureSession() {
        
        // AVCaptureVideoDataOutput is an object that receives raw video frames from the camera.
        let videoOutput = AVCaptureVideoDataOutput()    // Output to process frames
        
        guard permission else { return }    // Check if we have permission
        
        // Device that will be used as input for out session
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                  for: .video, position: .unspecified)
        
        // Set up capture input with our session
        guard
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
            session.canAddInput(videoDeviceInput)
            else { return }
            session.addInput(videoDeviceInput)
        
        // sampleBufferDelegate is an object that receives media frames from a capture session
        // Called when a new frame or sample buffer is available
        // self is the object that wants to handle the frames
        // DispatchQueue is the queue on which the delegate method should be called
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        
        // Connect the output
        session.addOutput(videoOutput)
    }
    
}

extension CameraCapture: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // captureOutput function is invoked whenever there is a new frame
    // Gives us the sample buffer
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        // Take the frame from the sample buffer and conver it into a cgImage
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else {return}
        
        // Send to main queue to the frame variable
        DispatchQueue.main.async { [unowned self] in
            self.frame = cgImage
        }
        
    }
    
    // Frame work for rendering images:
    // Get sample buffer (CoreMedia object)
    // Pass sample buffer to a image buffer or CVPixelBuffer (CoreVideo object)
    // Pass to CIImage (CoreImage object)
    // Convert to CGImage (CoreGraphics object)
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        
        // The sample buffer wraps a lower-level image (Core Video Pixel Buffer
        // The pixelBuffer contains the raw pixel data of the video frame
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        
        // Convert from CVPixelBuffer to CIImage
        // CIImage allows us to apply filters or process the image
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        
        // Convert CIImage to CGImage
        // CGImage allows us to convert to UIImage to display
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        
        return cgImage
    }
}
