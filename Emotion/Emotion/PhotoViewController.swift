//
//  PhotoViewController.swift
//  Emotion
//
//  Created by BumMo Koo on 2016. 11. 10..
//  Copyright © 2016년 BumMo Koo. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emotionLabel: UILabel!
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        updateEmotionLabel(emotion: nil)
    }
    
    // MARK: Action
    @IBAction private func tappedAdd(sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            self?.present(picker, animated: true, completion: nil)
        })
        let library = UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self?.present(picker, animated: true, completion: nil)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(camera)
        }
        alert.addAction(library)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Helper
    fileprivate func updateEmotionLabel(emotion: Emotion?) {
        if let 😶 = emotion {
            let string = "😡 Anger:\t\t\(😶.anger)\n😖\tContempt:\t\(😶.contempt)\n😒\tDisgust:\t\(😶.disgust)\n😱 Fear:\t\t\(😶.fear)\n😄 Happiness:\t\(😶.happiness)\n😐 Neutral:\t\(😶.neutral)\n😢 Sadness:\t\(😶.sadness)\n😮 Surprise\t\(😶.surprise)"
            emotionLabel.text = string
        } else {
            emotionLabel.text = "Add an image with a face to detect emotion.\n\nOnly result of first face is shown is multiple faces are found."
        }
    }
    
    fileprivate func drawRectIn(image: UIImage, faces: [Face]?) -> UIImage {
        var markedImage = image
        if let faces = faces {
            for face in faces {
                if let rect = face.faceRect?.cgRect {
                    if let newImage = image.mark(rect: rect) {
                        markedImage = newImage
                    }
                }
            }
        }
        return markedImage
    }
}

extension PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = nil
        updateEmotionLabel(emotion: nil)
        
        var image: UIImage?
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        image = info[UIImagePickerControllerEditedImage] as? UIImage ?? image
        imageView.image = image?.scale(width: 1000)
        
        if let image = image {
            API.requestEmotions(image: image, handler: { [weak self] faces in
                let face = faces?.first
                self?.updateEmotionLabel(emotion: face?.emotion)
                let markedImage = self?.drawRectIn(image: image, faces: faces)
                self?.imageView.image = markedImage
            })
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
