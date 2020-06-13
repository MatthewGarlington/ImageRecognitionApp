//
//  ViewController.swift
//  imageRecApp
//
//  Created by Matthew Garlington on 6/12/20.
//  Copyright © 2020 Matthew Garlington. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var ImageView: UIImageView!
    var chosenImage = CIImage()
    
    @IBOutlet weak var resultLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    @IBAction func changeButtonPressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        ImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        if let ciImage =  CIImage(image: ImageView.image!) {
            chosenImage = ciImage
        
                
                
        }
        
        recognizeImage(image: chosenImage)
        
    }
    
    func recognizeImage(image: CIImage) {
        
        // Step 1) request
        // Step 2) Handler
        if let model = try? VNCoreMLModel(for: MobileNetV2().model) {
            let request = VNCoreMLRequest(model: model) { (vnrequest, error) in
                
               if let results = vnrequest.results as? [VNClassificationObservation] {
                if results.count > 0 {
                
                let topResult = results.first
                
                    DispatchQueue.main.async {
                        
                        let confidenceLevel = (topResult?.confidence ?? 0) * 100
                        
                        self.resultLabel.text = "\(confidenceLevel)% it's \(topResult?.identifier)"
                    }
        }
    
    }
}
            let handler = VNImageRequestHandler(ciImage: image)
                   DispatchQueue.global(qos: .userInteractive).async {
                    do {
                    try handler.perform([request])
                    } catch {
                        print(error)
                    }
                    }
}
        
       
        }
}

