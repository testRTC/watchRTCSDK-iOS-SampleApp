//
//  AblySignallingClient.swift
//  WebRTC-Demo
//
//  Created by  Yulian on 11.04.2023.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import Ably
import WebRTC

enum AblyMessage: String {
    case sdp
    case candidate
}

final class AblySignallingClient: SignallingClientProtocol {
    private let ablyRealtimeClient: ARTRealtime
    private var channel: ARTRealtimeChannel?
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private weak var delegate: SignalClientDelegate?
    
    init(apiKey: String) {
        let options = ARTClientOptions(key: apiKey)
        options.autoConnect = false
        options.echoMessages = false
        ablyRealtimeClient = ARTRealtime(options: options)

        ablyRealtimeClient.connection.on { stateChange in
            switch stateChange.current {
            case .connected:
                self.delegate?.signalClientDidConnect(self)
            case .disconnected:
                self.delegate?.signalClientDidDisconnect(self)
                
                // try to reconnect every two seconds
                DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                    debugPrint("Trying to reconnect to ably signaling server...")
                    self.ablyRealtimeClient.connect()
                }
            case .failed:
                print("Ably connection failled: \(String(describing: stateChange.reason))")
            default:
                break
            }
        }
    }
    
    func setDelegate(_ delegate: SignalClientDelegate) {
        self.delegate = delegate
    }
    
    func connect(_ roomName: String) {
        ablyRealtimeClient.connect()
        channel = ablyRealtimeClient.channels.get(roomName)
        
        func onMessageReceived(message: ARTMessage) {
            let decodedMessage: Message
            do {
                decodedMessage = try self.decoder.decode(Message.self, from: message.data as! Data)
            } catch {
                debugPrint("Warning: Could not decode incoming message: \(error)")
                return
            }
            
            switch decodedMessage {
            case .candidate(let iceCandidate):
                self.delegate?.signalClient(self, didReceiveCandidate: iceCandidate.rtcIceCandidate)
            case .sdp(let sessionDescription):
                self.delegate?.signalClient(self, didReceiveRemoteSdp: sessionDescription.rtcSessionDescription)
            }
        }
        
        channel?.subscribe(AblyMessage.sdp.rawValue) { message in
            print("Received SDP: \(message.data ?? "nil")")
            onMessageReceived(message: message)
        }
        
        channel?.subscribe(AblyMessage.candidate.rawValue) { message in
            print("Received Candidate: \(message.data ?? "nil")")
            onMessageReceived(message: message)
        }
    }
    
    func disconnect() {
        channel?.unsubscribe()
        channel = nil
        
        ablyRealtimeClient.close()
    }
    
    func send(sdp rtcSdp: RTCSessionDescription) {
        let message = Message.sdp(SessionDescription(from: rtcSdp))
        do {
            let dataMessage = try self.encoder.encode(message)

            self.channel?.publish(AblyMessage.sdp.rawValue, data: dataMessage)
        } catch {
            debugPrint("Warning: Could not encode sdp: \(error)")
        }
    }

    func send(candidate rtcIceCandidate: RTCIceCandidate) {
        let message = Message.candidate(IceCandidate(from: rtcIceCandidate))
        do {
            let dataMessage = try self.encoder.encode(message)
            self.channel?.publish(AblyMessage.candidate.rawValue, data: dataMessage)
        } catch {
            debugPrint("Warning: Could not encode candidate: \(error)")
        }
    }
}
