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
    
    var streamView: UIView?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    let streamer = HaishinStreamer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startStream()
        
        streamView = streamer.getStreamView(frame: view.bounds)
        view.insertSubview(streamView!, belowSubview: previewView)
    }

    override func viewDidLayoutSubviews() {
        streamView?.frame = view.bounds
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil) { (_) in
            UIView.setAnimationsEnabled(true)
        }
        UIView.setAnimationsEnabled(false)
        super.viewWillTransition(to: size, with: coordinator)
    }

    @IBAction func switchCameras() {
//        streamer
        streamer.switchCamera()
    }
    
    @IBAction func startStream() {
        streamer.stream()
    }
}

extension UIInterfaceOrientation {
    var videoOrientation: AVCaptureVideoOrientation? {
        switch self {
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeRight: return .landscapeRight
        case .landscapeLeft: return .landscapeLeft
        case .portrait: return .portrait
        default: return nil
        }
    }
}

