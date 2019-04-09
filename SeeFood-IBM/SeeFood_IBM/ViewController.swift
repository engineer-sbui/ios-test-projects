//
//  ViewController.swift
//  SeeFood_IBM
//
//  Created by Steven Bui on 4/8/19.
//  Copyright © 2019 Steven Bui. All rights reserved.
//

import UIKit
import VisualRecognition

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    let apiKey = ""
    let version = "2019-04-08"
    
    var classificationResults : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
            
            let visualRecognition = VisualRecognition(version: version, apiKey: apiKey)
            
            guard let imageData = image.jpegData(compressionQuality: 0.01) else {
                fatalError("Compression failed")
            }
            
            guard let smallerImage = UIImage(data: imageData) else {
                fatalError("Image data conversion failed")
            }
            
            visualRecognition.classify(image: smallerImage) { (response, error) in
                if let err = error {
                    print(err)
                }
                if let classfiedImages = response?.result {
                    
                    self.classificationResults = []
                    
                    let classes = classfiedImages.images.first!.classifiers.first!.classes
                    
                    for index in 0..<classes.count {
                        self.classificationResults.append(classes[index].className)
                    }
                    
                    print(self.classificationResults)
                    
                    if self.classificationResults.contains("hotdog") {
                        DispatchQueue.main.async {
                            self.navigationItem.title = "Hotdog!"
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.navigationItem.title = "Not Hotdog!"
                        }
                    }
                }
            }
        }
        else {
            print("Error picking image")
        }
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}

