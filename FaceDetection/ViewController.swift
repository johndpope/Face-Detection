//
//  ViewController.swift
//  FaceDetection
//
//  Created by Kirill on 12/14/18.
//  Copyright © 2018 Kirill. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = UIImage(named: "face3") else { return }
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        let scaledHeight = view.frame.width / image.size.width * image.size.height
        
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: scaledHeight)
        
        view.addSubview(imageView)
        
        let request = VNDetectFaceRectanglesRequest { (req, err) in
            
            if let err = err {
                print("Failed to detect faces:", err)
                return
            }
            
            print(req.results?.count)
            
            if req.results?.count == 0 {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "No faces", message: "", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            req.results?.forEach({ (res) in
                
                DispatchQueue.main.async {
                    guard let faceObservation = res as? VNFaceObservation else { return }
                    
                    let x = imageView.frame.width * faceObservation.boundingBox.origin.x
                    
                    let height = scaledHeight * faceObservation.boundingBox.height
                    
                    let y = scaledHeight * (1 -  faceObservation.boundingBox.origin.y) - height
                    
                    let width = imageView.frame.width * faceObservation.boundingBox.width
                    
                    let redView = UIView()
                    redView.backgroundColor = .green
                    redView.alpha = 0.4
                    redView.frame = CGRect(x: x, y: y, width: width, height: height)
                    self.view.addSubview(redView)
                }
            })
        }
        
        guard let cgImage = image.cgImage else { return }
        
        DispatchQueue.global().async {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch let reqErr {
                print("Failed to perform request:", reqErr)
            }
        }
    }
    
}

