//
//  ViewController.swift
//  Camera
//
//  Created by Rizwan on 16/06/17.
//  Copyright © 2017 Rizwan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet weak var streamButton: UIButton!
    @IBOutlet weak var switchCamera: UIButton!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    let streamer = LVLiveStreamer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startStream()
        streamer.session.preView = previewView
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil) { (_) in
            UIView.setAnimationsEnabled(true)
        }
        UIView.setAnimationsEnabled(false)
        super.viewWillTransition(to: size, with: coordinator)
    }

    @IBAction func switchCameras() {
//        streamer.switchCamera()
    }
    
    @IBAction func startStream() {
        streamer.stream()
    }
}
