//
//  ImageSaver.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/9/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import Foundation
import UIKit

class ImageSaver: NSObject {
    
    var completion: ((Error?) -> Void) = { _ in }

    func saveImage(image: UIImage, completion: @escaping (Error?) -> Void) {
        self.completion = completion
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            completion(error)
            return
        }
        
        completion(nil)
    }
}
