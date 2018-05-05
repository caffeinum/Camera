//
//  Streamer.swift
//  Camera
//
//  Created by caffeinum on 05/05/2018.
//  Copyright © 2018 Rizwan. All rights reserved.
//

import Foundation
import AVFoundation
import HaishinKit

class HaishinStreamer {
    var session: AVAudioSession
    var rtmpConnection: RTMPConnection
    var rtmpStream: RTMPStream
    var position: AVCaptureDevice.Position = .front {
        didSet {
            changeCamera(position)
        }
    }
    
    init(av_session: AVAudioSession = AVAudioSession.sharedInstance()) {
        do {
            session = av_session

            try session.setPreferredSampleRate(44_100)
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .allowBluetooth)
            try session.setMode(AVAudioSessionModeDefault)
            try session.setActive(true)
        } catch {}
        
        rtmpConnection = RTMPConnection()
        rtmpStream = RTMPStream(connection: rtmpConnection)
    }
    
    func getStreamView(frame: CGRect) -> UIView {
        let lfView: LFView = LFView(frame: frame)
        lfView.videoGravity = .resizeAspect
        lfView.attachStream(rtmpStream)
        
        return lfView
    }
    
    func switchCamera() {
        position = position == .front ? .back : .front
    }
    
    func changeCamera(_ position: AVCaptureDevice.Position) {
        let camera = DeviceUtil.device(withPosition: position)

        rtmpStream.attachCamera(camera) { error in
            print(error)
        }
    }
    
    func stream() {
        let audio = AVCaptureDevice.default(for: AVMediaType.audio)
        let camera = DeviceUtil.device(withPosition: position)
        
        rtmpStream.attachAudio(audio) { error in
             print(error)
        }
        
        rtmpStream.attachCamera(camera) { error in
             print(error)
        }

//        rtmpStream.videoSettings = [
//            "width" : 1280, "height" : 720,
//            "bitrate" : 500_000
//        ]

        rtmpStream.captureSettings = [
            "sessionPreset": AVCaptureSession.Preset.hd1280x720
        ]

        rtmpStream.orientation = .landscapeLeft
        rtmpStream.syncOrientation = true
        rtmpConnection.connect("rtmp://phystech.tv/studio107")
        rtmpStream.publish("cam")
    }
}
