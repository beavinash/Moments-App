//
//  NewsfeedTableViewController.swift
//  Moments-App
//
//  Created by Avinash Reddy on 5/30/18.
//  Copyright © 2018 Avinash Reddy. All rights reserved.
//

import UIKit
import Firebase

class NewsfeedTableViewController: UITableViewController {
    
    struct Storyboard {
        static let showWelcome = "showWelcomeVC"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                
            } else {
                self.performSegue(withIdentifier: Storyboard.showWelcome, sender: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}
