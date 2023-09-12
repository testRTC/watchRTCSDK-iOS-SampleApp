# Sample WebRTC iOS app with integrated WatchRTC SDK
A simple native WebRTC demo iOS app using swift. 

WatchRTC is integrated into the app through Swift Package Manager.

For sample app with WatchRTC integrated through Cocoapods, see: [https://github.com/testRTC/watchRTCSDK-iOS-SampleApp/tree/cocoapodsIntegration](https://github.com/testRTC/watchRTCSDK-iOS-SampleApp/tree/cocoapodsIntegration)

This app use [Ably signalling](https://ably.com/) by default, so disregard information about signalling server setup from [Setup instructions](https://github.com/testRTC/watchRTCSDK-iOS-SampleApp#setup-instructions), [Starting NodeJS signaling server](https://github.com/testRTC/watchRTCSDK-iOS-SampleApp#starting-nodejs-signaling-server) and [Starting Swift signaling server](https://github.com/testRTC/watchRTCSDK-iOS-SampleApp#starting-swift-signaling-server) sections. However, local signalling server can still be used. In order to use it, call **buildSocketSignalingClient()** method in **AppDelegate.swift** file.

All of the `WatchRTC` related code is located in [WebRTCClient.swift](WebRTC-Demo-App/Sources/Services/WebRTCClient.swift)

![Screenshots](images/WebRTC.png)

## Disclaimer
This demo app's purpose is to demonstrate the bare minimum required to establish peer to peer connection with WebRTC. **This is not a production ready code!** In order to have a production VoIP app you will need to have a real signaling server (not a simple broadcast server like in this example), deploy your own Turn server(s) and probably integrate CallKit and push notifications.

## Requirements
1. Xcode 13 or later
2. iOS 13 or later
3. Node.js + npm (For NodeJS Signaling server)  
**- OR -**  
macOS 10.15 (For Swift signaling server)  
**- OR -**  
Ably account to get an API_KEY (For Ably signalling)  

## Setup instructions
1. Start the signaling server (Either NodeJS or Swift). Skip this step in case of Ably signalling, which is enabled by default
2. Navigate to `WebRTC-Demo-app` folder
3. Open `WebRTC-Demo.xcworkspace`
4. Open `Config.swift` and set the `defaultSignalingServerUrl` variable to your signaling server ip/host. Don't use `localhost` or `127.0.0.1` if you plan to connect other devices in your network to your mac. Skip this step in case of Ably signalling.
5. Build and run on devices or on a simulator (video capture is not supported on a simulator).

## Starting NodeJS signaling server
    1. Navigate to the `signaling/NodeJS` folder.
    2. Run `npm install` to install all dependencies.
    3. Run `node app.js` to start the server.

## Starting Swift signaling server
Note: This step requires MacOS 10.15

    1. Navigate to the `signaling/Swift` folder.
    2. Run `make`
    3. Run `./server` to start the server

Alternative method: Open `WebRTC-Demo.xcworkspace` and run the `SignalingServer` scheme.

## Run instructions
1. Run the app on two devices with the signaling server running.
2. Make sure both of the devices are connected to the signaling server.
3. On the first device, click on 'Send offer' - this will generate a local offer SDP and send it to the other client using the signaling server.
4. Wait until the second device receives the offer from the first device (you should see that a remote SDP has arrived).
5. Click on 'Send answer' on the second device.
6. when the answer arrives to the first device, both of the devices should be now connected to each other using webRTC, try to talk or click on the 'video' button to start capturing video.
7. To restart the process, kill both apps and repeat steps 1-6.
