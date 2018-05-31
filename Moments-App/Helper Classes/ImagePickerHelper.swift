//
//  ImagePickerHelper.swift
//  Moments-App
//
//  Created by Avinash Reddy on 5/30/18.
//  Copyright © 2018 Avinash Reddy. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

// Alias name for completion code
typealias ImagePickerHelperCompletion = ((UIImage?) -> Void)!

class ImagePickerHelper: NSObject {
    
    weak var viewController: UIViewController!
    var completion: ImagePickerHelperCompletion
   
    
    init(viewController: UIViewController, completion: ImagePickerHelperCompletion) {
        self.viewController = viewController
        self.completion = completion
        
        super.init()
        self.showPhotoSourceSelection()
    }
    
    func showPhotoSourceSelection() {
        let actionSheet = UIAlertController(title: "Pick a Photo", message: "Would you like to open Photos Library or Camera", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "camera", style: .default) { (action) in
            self.showImagePicker(sourceType: .camera)
        }
        let photosLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.showImagePicker(sourceType: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photosLibraryAction)
        actionSheet.addAction(cancelAction)
        
        viewController.present(actionSheet, animated: true, completion: nil)
    }
    
    func showImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.delegate = self
        viewController.present(imagePicker, animated: true, completion: nil)
    }
}

extension ImagePickerHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        viewController.dismiss(animated: true, completion: nil)
        completion(image)
    }
}
