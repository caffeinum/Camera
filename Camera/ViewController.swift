//
//  ViewController.swift
//  Camera
//
//  Created by Rizwan on 16/06/17.
//  Copyright © 2017 Rizwan. All rights reserved.
//

import UIKit
import AVFoundation
import LFLiveKit

class ViewController: UIViewController {
    @IBOutlet weak var previewView: UIView!

    @IBOutlet weak var stream1: UIButton!
    @IBOutlet weak var stream2: UIButton!
    var currentStreamButton: UIButton {
        return (streamKey == "cam1") ? stream1 : stream2
    }

    var streamKey: String?
    var isStreaming: Bool {
        return streamer.session.state == .start
    }
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    let streamer = LVLiveStreamer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startStream()
        streamer.session.delegate = self
        streamer.session.preView = previewView
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil) { (_) in
            UIView.setAnimationsEnabled(true)
        }
        UIView.setAnimationsEnabled(false)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func startStream(key: String = "cam1") {
        streamKey = key
        
        streamer.stream(to: streamKey)
    }

    @IBAction func startStream1() {
        if isStreaming {
            streamer.stop()
        } else {
            startStream(key: "cam1")
        }
    }

    @IBAction func startStream2() {
        if isStreaming {
            streamer.stop()
        } else {
            startStream(key: "cam2")
        }
    }
    
    func updateButton() {
        if isStreaming {
            currentStreamButton.setTitle("stop", for: .normal)
        } else {
            stream1.setTitle("cam1", for: .normal)
            stream2.setTitle("cam2", for: .normal)
        }
    }
}

extension ViewController: LFLiveSessionDelegate {
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print("[DEBUG]", debugInfo)
    }
    
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        print("[STATE CHANGE]", state.rawValue)
        
        if (state == .error) {
            streamer.stop()
            startStream(key: "cam2")
        }
        
        updateButton()
    }
}
