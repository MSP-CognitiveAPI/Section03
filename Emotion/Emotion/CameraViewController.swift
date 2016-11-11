//
//  CameraViewController.swift
//  Emotion
//
//  Created by BumMo Koo on 2016. 11. 9..
//  Copyright © 2016년 BumMo Koo. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    @IBOutlet fileprivate weak var imageView: UIImageView!
    
    fileprivate var frameGrabCounter = 0
    
    let session = AVCaptureSession()
    let camera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    var output: AVCaptureVideoDataOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
            session.startRunning()
            setVideoOrientation()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setVideoOrientation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if session.isRunning == true {
            session.stopRunning()
        }
    }
    
    // MARK: Action
    private func setupCamera() {
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        guard let input = try? AVCaptureDeviceInput(device: camera) else { return }
        session.addInput(input)
        
        let output = AVCaptureVideoDataOutput()
        let queue = DispatchQueue(label: "captureQueue")
        output.setSampleBufferDelegate(self, queue: queue)
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
        self.output = output
        session.addOutput(output)
        
        guard let preview = AVCaptureVideoPreviewLayer(session: session) else { return }
        preview.videoGravity = AVLayerVideoGravityResizeAspect
        view.layer.insertSublayer(preview, at: 0)
        previewLayer = preview
    }
    
    private func setVideoOrientation() {
        let previewConneciton = previewLayer?.connection
        let outConnection = output?.connections.first as? AVCaptureConnection
        
        switch UIDevice.current.orientation {
        case .portrait:
            previewConneciton?.videoOrientation = .portrait
            outConnection?.videoOrientation = .portrait
        case .landscapeLeft:
            previewConneciton?.videoOrientation = .landscapeRight
            outConnection?.videoOrientation = .landscapeRight
        case .landscapeRight:
            previewConneciton?.videoOrientation = .landscapeLeft
            outConnection?.videoOrientation = .landscapeLeft
        case .portraitUpsideDown:
            previewConneciton?.videoOrientation = .portraitUpsideDown
            outConnection?.videoOrientation = .portraitUpsideDown
        default: break
        }
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let image = UIImage(ciImage: ciImage).scale(width: imageView.bounds.width)
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))

        frameGrabCounter += 1
//        print(frameGrabCounter)
        if self.frameGrabCounter % 120 == 0 { // 40 per sec on iPhone 6s; 20 API calls available per minute
            OperationQueue.main.addOperation { [weak self] in
                self?.imageView.image = nil
                API.requestEmotions(image: image, handler: { (faces) in
                    if let faces = faces {
                        var string = ""
                        for face in faces {
                            guard let emoji = face.emotion?.findEmotion().emoji else { continue }
                            string += emoji
                            string += "\n"
                        }
                        let image = image.mark(faces: faces, showImage: false)
                        self?.imageView.image = image
                    }
                })
            }
        }
    }
}
