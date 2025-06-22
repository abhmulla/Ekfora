//
//  StreamManager.swift
//  iosclient
//
//  Created by Abdulelah Mulla on 6/16/25.
//

import Foundation
import UIKit

struct Streams {
    let input: InputStream
    let output: OutputStream
}


class StreamManager: NSObject, URLSessionDelegate, StreamDelegate, URLSessionWebSocketDelegate {
    
    lazy var streamSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
    
    private var webSocket : URLSessionWebSocketTask?
    
    func connect() {
        //192.168.1.79
        let url = URL(string: "ws://192.168.1.27:7890")!
        
//        lazy var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval:  10)
//        request.httpMethod = "POST"
//        let uploadTask = streamSession.uploadTask(withStreamedRequest: request)
//        uploadTask.resume()
        webSocket = streamSession.webSocketTask(with: url)
        webSocket?.resume()  // handles connection and handshake
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
           print("Connected to server")
       }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Disconnect from Server")
    }
    
    
    func send(_ data: Data){
         /*
          - Create a workItem
          - Add it to the Queue
          */
         
         let workItem = DispatchWorkItem{
             
             self.webSocket?.send(.data(data), completionHandler: { error in
                 if let error = error {
                     print(error)
                 }
             })
         }
         
         DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: workItem)
     }
    
}
