//
//  SignUpTableViewController.swift
//  Moments-App
//
//  Created by Avinash Reddy on 5/30/18.
//  Copyright © 2018 Avinash Reddy. All rights reserved.
//

import UIKit
import Firebase

class SignUpTableViewController: UITableViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var imagePickerHelper: ImagePickerHelper!
    var profileImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create New Account"
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        profileImageView.layer.masksToBounds = true
        
        emailTextField.delegate = self
        fullNameTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createNewAccountDidTap() {
        // create a new account
        // save the user data, take a photo
        // login the user
        
        if emailTextField.text != ""
            && (passwordTextField.text?.count)!  > 6
            && (usernameTextField.text?.count)! > 6
            && fullNameTextField.text != ""
            && profileImage != nil {
            
            let username = usernameTextField.text!
            let fullName = fullNameTextField.text!
            let email = emailTextField.text!
            let password = passwordTextField.text!
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { (firUser, error) in
                if error != nil {
                    // report error
                } else if let firUser = firUser {
                    let newUser = User(uid: firUser.uid, username: username, fullName: fullName, bio: "", website: "", profileImage: self.profileImage, follows: [], followedBy: [])
                    newUser.save(completion: { (error) in
                        if error != nil {
                            // report
                        } else {
                            // Login User
                            Auth.auth().signIn(withEmail: email, password: password, completion: { (firUser, error) in
                                if let error = error {
                                    // report error
                                    print(error)
                                } else {
                                    self.dismiss(animated: true, completion: nil)
                                }
                            })
                        }
                    })
                }
            })
        }
    }
    
    @IBAction func changeProfilePhotoDidTap(_ sender: Any) {
        imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
            self.profileImageView.image = image
            self.profileImage = image
        })
    }
    
    @IBAction func backDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SignUpTableViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            fullNameTextField.becomeFirstResponder()
        } else if textField == fullNameTextField {
            usernameTextField.becomeFirstResponder()
        } else if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            createNewAccountDidTap()
        }
        
        return true
    }
}
