//
//  CameraView.swift
//  iosclient
//
//  Created by Abdulelah Mulla on 6/3/25.
//

import SwiftUI

struct CameraView: View {
    
    @StateObject private var model = CameraCapture()
    
    var body: some View {
        
        CameraStreamView(image: model.frame)
    }
}

#Preview {
    CameraView()
}
