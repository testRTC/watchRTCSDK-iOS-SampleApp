//
//  SignallingClientProtocol.swift
//  WebRTC-Demo
//
//  Created by  Yulian on 12.04.2023.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import WebRTC

protocol SignallingClientProtocol {
    func setDelegate(_ delegate: SignalClientDelegate)
    func connect(_ roomName: String)
    func disconnect()
    func send(sdp rtcSdp: RTCSessionDescription)
    func send(candidate rtcIceCandidate: RTCIceCandidate)
}

protocol SignalClientDelegate: AnyObject {
    func signalClientDidConnect(_ signalClient: SignallingClientProtocol)
    func signalClientDidDisconnect(_ signalClient: SignallingClientProtocol)
    func signalClient(_ signalClient: SignallingClientProtocol, didReceiveRemoteSdp sdp: RTCSessionDescription)
    func signalClient(_ signalClient: SignallingClientProtocol, didReceiveCandidate candidate: RTCIceCandidate)
}
