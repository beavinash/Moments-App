//
//  FIRImage.swift
//  Moments-App
//
//  Created by Avinash Reddy on 5/28/18.
//  Copyright © 2018 Avinash Reddy. All rights reserved.
//

import Foundation
import Firebase

class FIRImage {
    var image: UIImage
    var downloadURL: URL?
    var downlaodLink: String!
    var ref: StorageReference!
    
    init(image: UIImage) {
        self.image = image
    }
}

extension FIRImage {
    func saveProfileImage(_ userUID: String, _ completion: @escaping (Error?) -> Void) {
        let resizedImage = image.resized()
        let imageData = UIImageJPEGRepresentation(resizedImage, 0.9)
        ref = WAStorageReference.profileImages.reference().child(userUID) // ~/profileImages/userUID123
        
        downlaodLink = ref.description
        
        ref.putData(imageData!, metadata: nil) { (metaData, error) in
            completion(error)
        }
        
    }
    
    func save(_ uid: String, completion: @escaping (Error?) -> Void) {
        let resizedImage = image.resized()
        let imageData = UIImageJPEGRepresentation(resizedImage, 0.9)
        ref = WAStorageReference.images.reference().child(uid) // ~/images/uid123123123
        
        downlaodLink = ref.description
        
        ref.putData(imageData!, metadata: nil) { (metaData, error) in
            completion(error)
        }
    }
}

extension FIRImage {
    class func downloadProfileImage(_ uid: String, completion: @escaping (UIImage?, Error?) -> Void) {
        WAStorageReference.profileImages.reference().child(uid).getData(maxSize: 1 * 1024 * 1024) { (imageData, error) in
            if error == nil && imageData != nil {
                let image = UIImage(data: imageData!)
                completion(image, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func downloadImage(uid: String, completion: @escaping (UIImage?, Error?) -> Void) {
        WAStorageReference.images.reference().child(uid).getData(maxSize: 1 * 1024 * 1024) { (imageData, error) in
            if error == nil && imageData != nil {
                let image = UIImage(data: imageData!)
                completion(image, error)
            } else {
                completion(nil, error)
            }
        }
    }
}

private extension UIImage {
    func resized() -> UIImage {
        let height: CGFloat = 800.00
        let ratio = self.size.width / self.size.height
        let width = height * ratio
        
        let newSize = CGSize(width: width, height: height)
        let newRectangle = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: newRectangle)
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
}
