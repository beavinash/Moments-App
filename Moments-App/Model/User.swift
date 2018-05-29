//
//  User.swift
//  Moments-App
//
//  Created by Avinash Reddy on 5/28/18.
//  Copyright © 2018 Avinash Reddy. All rights reserved.
//

import Foundation
import Firebase


class User {
    let uid: String
    var username: String
    var fullName: String
    var bio: String
    var website: String
    var profileImage: UIImage?
    
    
    var follows: [User] // what users i follow
    var followedBy: [User] // what users are followed me
    
    //MARK: - Initializers
    init(uid: String, username: String, fullName: String, bio: String, website: String, profileImage: UIImage?, follows: [User], followedBy: [User]) {
        self.uid = uid
        self.username = username
        self.fullName = fullName
        self.bio = bio
        self.website = website
        self.profileImage = profileImage
        self.follows = follows
        self.followedBy = followedBy
    }
    
    // when downloaded data will be in snapshot. and this as to be in dictionary
    init(dictionary: [String: Any]) {
        uid = dictionary["uid"] as! String
        username = dictionary["username"] as! String
        fullName = dictionary["fullName"] as! String
        bio = dictionary["bio"] as! String
        website = dictionary["website"] as! String
        
        // follows
        self.follows = []
        if let followsDict = dictionary["follows"] as? [String: Any] {
            for (_, userDict) in followsDict {
                if let userDict = userDict as? [String: Any] {
                    self.follows.append(User(dictionary: userDict))
                }
            }
        }
        
        // followedBy
        
        followedBy = []
        if let followedByDict = dictionary["followedBy"] as? [String : Any] {
            for (_, userDict) in followedByDict {
                if let userDict = userDict as? [String : Any] {
                    self.followedBy.append(User(dictionary: userDict))
                }
            }
        }
    }
    
    // for ProfileImage, follows, followedBy
    func save(completion: @escaping (Error?) -> Void) {
        let ref = WADatabaseReference.users(uid: uid).reference() // .reference() - check firebase doc
        ref.setValue(toDictionary())
        
        // save follows
        for user in follows {
            ref.child("follows/\(user.uid)").setValue(user.toDictionary())
        }
        
        // save followedBy
        for user in followedBy {
            ref.child("followedBy/\(user.uid)").setValue(user.toDictionary())
        }
        
        // save profileImage
        if let profileImage = self.profileImage {
            let firImage = FIRImage(image: profileImage)
            firImage.saveProfileImage(self.uid) { (error) in
                completion(error)
            }
        }
    }
    
    func toDictionary() -> [String: Any] {
        return [
            
            "uid": uid,
            "username": username,
            "fullName": fullName,
            "bio": bio,
            "website": website,
        
        ]
    }
    
    
}
