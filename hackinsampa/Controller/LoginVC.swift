//
//  LoginVC.swift
//  hackinsampa
//
//  Created by Carlos Doki on 16/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SwiftKeychainWrapper
import FirebaseAuth
import Firebase

class LoginVC: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var loginView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//            KeychainWrapper.standard.removeObject(forKey: KEY_UID)
//            exit(0)
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
        
        let loginButton = FBSDKLoginButton()
        loginView.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 50, width: loginView.frame.width - 32, height: 50)
        loginButton.delegate = self
        
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did logout Facebook")
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        print("Sucessfully logged in with Facebook...")
        let credentials = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if let err = error {
                print("Failed to create a Firebase User", err)
                return
            }
            
            guard let uid = user?.uid else { return }
            userUUID = uid
            let ref = Database.database().reference()
            let users = ref.child("users").child(uid)

            users.child("cpf").setValue("")
            users.child("IDFacebook").setValue(user?.uid)
            users.child("nome").setValue(user?.displayName)
            
            let keychainResult = KeychainWrapper.standard.set((user?.uid)!, forKey: KEY_UID)
            print("DOKI: Data saved to keychain \(keychainResult)")
            
            print("Firebase user created", uid)
            self.performSegue(withIdentifier: "menuinicial", sender: nil)
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {        
        if let user = KeychainWrapper.standard.string(forKey: KEY_UID) {
            userUUID = user
            print("DOKI: ID found in keychain")
            performSegue(withIdentifier: "menuinicial", sender: nil)
        } else {
        }
    }
    
}
