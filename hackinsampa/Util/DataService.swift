//
//  DataService.swift
//  hackinsampa
//
//  Created by Carlos Doki on 16/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = Database.database().reference()

class DataService {
    static let ds = DataService()
    
    // DB References
    private var _REF_BASE = DB_BASE
    //private var _REF_POSTS = DB_BASE.child("licitacao").child("post")
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_CHATS = DB_BASE.child("chats")
    private var _REF_ORGAO = DB_BASE.child("orgao")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
     
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_CHATS: DatabaseReference {
        return _REF_CHATS
    }
    
    var REF_ORGAO: DatabaseReference {
        return _REF_ORGAO
    }

    var REF_USER_CURRENT: DatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
}
