//
//  FirebaseReference.swift
//  Moments-App
//
//  Created by Avinash Reddy on 5/28/18.
//  Copyright © 2018 Avinash Reddy. All rights reserved.
//

import Foundation
import Firebase

enum WADatabaseReference {
    case root
    case users(uid: String)
    case media                  // for Posts
    case chats
    case messages
    
    private var rootRef: DatabaseReference {
        return Database.database().reference()
    }
    
    // MARK: - Public
    
    func reference() -> DatabaseReference {
        return rootRef.child(path)
    }
    
    private var path: String {
        switch self {
        case .root:
            return ""
        case .users(let uid):
            return "users/\(uid)"
        case .media:
            return "media"
        case .chats:
            return "chats"
        case .messages:
            return "messages"
        }
    }
}

enum WAStorageReference {
    case root
    case images         // for post
    case profileImages  // for user
    
    private var baseRef: StorageReference {
        return Storage.storage().reference()
    }
    
    func reference() -> StorageReference {
        return baseRef.child(path)
    }
    
    private var path: String {
        switch self {
        case .root:
            return ""
        case .images:
            return "images"
        case .profileImages:
            return "profileImages"
        }
    }
}
