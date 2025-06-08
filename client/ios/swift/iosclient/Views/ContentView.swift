//
//  ContentView.swift
//  iosclient
//
//  Created by Abdulelah Mulla on 6/1/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            VStack {
                Text("Hello, world!")
                Text("To begin, please navigate to the camera stream option.")
                
            }
            .padding()
            NavigationLink("Camera Stream", destination: CameraView())
        }
    }
}

#Preview {
    ContentView()
}
