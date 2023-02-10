//
//  StarscreamProvider.swift
//  WebRTC-Demo
//
//  Created by stasel on 15/07/2019.
//  Copyright © 2019 stasel. All rights reserved.
//

import Foundation
import Starscream

class StarscreamWebSocket: WebSocketProvider {

    var delegate: WebSocketProviderDelegate?
    private let socket: WebSocket

    init(url: URL) {
        let request = URLRequest(url: url)
        self.socket = WebSocket(request: request)
//        self.socket = WebSocket(url: url)
        self.socket.delegate = self
    }

    func connect() {
        self.socket.connect()
    }

    func send(data: Data) {
        self.socket.write(data: data)
    }
}

extension StarscreamWebSocket: Starscream.WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        debugPrint("did receive...")
    }

    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        debugPrint("did receive...")
    }

    func websocketDidConnect(socket: WebSocketClient) {
        self.delegate?.webSocketDidConnect(self)
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        self.delegate?.webSocketDidDisconnect(self)
    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        debugPrint("Warning: Expected to receive data format but received a string. Check the websocket server config.")
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        self.delegate?.webSocket(self, didReceiveData: data)
    }

}
