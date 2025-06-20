//
//  CameraStreamView.swift
//  iosclient
//
//  Created by Abdulelah Mulla on 6/2/25.
//

import SwiftUI
import UIKit

struct CameraStreamView: View {
    
    var image : CGImage?
    
    private let label = Text("frame")
    
    var body: some View {
        if let image = image {
            Image(image, scale: 1.0, orientation: .right, label: label)
                .resizable()
                .scaledToFit()
        } else {
            ProgressView("Loading...")
        }
    }
}
 
#Preview {
    CameraStreamView()
}
