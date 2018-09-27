//
//  Streamer.swift
//  Camera
//
//  Created by caffeinum on 05/05/2018.
//  Copyright © 2018 Rizwan. All rights reserved.
//

import Foundation
import AVFoundation
import LFLiveKit

@objc class LVLiveStreamer: NSObject {
    var session: LFLiveSession!

    func getStreamInfo(rtmpURL: String) -> LFLiveStreamInfo {
        let info = LFLiveStreamInfo()
        info.url = rtmpURL
        return info
    }

    override init() {
        super.init()

        let audioConfiguration = LFLiveAudioConfiguration()
        audioConfiguration.numberOfChannels = 2
        audioConfiguration.audioBitrate = ._128Kbps
        audioConfiguration.audioSampleRate = ._44100Hz

        let videoConfiguration = LFLiveVideoConfiguration()
        videoConfiguration.videoSize = CGSize(width: 1280, height: 720)
        videoConfiguration.videoBitRate = 600*1024
        videoConfiguration.videoMaxBitRate = 3000*1024
        videoConfiguration.videoMinBitRate = 200*1024
        videoConfiguration.videoFrameRate = 25
        videoConfiguration.videoMaxKeyframeInterval = 30
        videoConfiguration.outputImageOrientation = .landscapeLeft
        videoConfiguration.sessionPreset = .captureSessionPreset720x1280
        
        session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration, captureType: .captureMaskAll)
    }
    
    func stream(to key: String? = nil) {
        let key = key ?? String.random(length: 2)
        
        print("[STREAM] key =", key)

        let url = "rtmp://phystech.tv/sources/\(key)"
        let streamInfo = getStreamInfo(rtmpURL: url)
        
        session.running = true
        session.startLive(streamInfo)
    }
    
    func stop() {
        session.stopLive()
    }
}

extension String {
    static func random(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyz"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}
