//
//  SignInVC.swift
//  Devslopes-Social
//
//  Created by Araz Sinjary on 8/28/18.
//  Copyright © 2018 Araz Sinjary. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("Keychain: id found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }

    @IBAction func facebookBtnPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                print("FB: Unable to authenticate with facebook - \(error!)")
            } else if result?.isCancelled == true {
                print("FB: User cancelled facebook authentication")
            } else {
                print("FB: Successfully autheticated with facebook")
                let credentail = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credentail)
            }
        }
        
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            
            if error != nil {
                print("FB Unable to authenticate with firebase - \(error!)")
            } else {
                print("FB: Successfully authenticated with firebase")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            }
        }
    }
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error ) in
                if error == nil {
                    print("Email: user authenticate with firebase")
                    if user != nil {
                        self.completeSignIn(id: "2")//for id i just put string
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("Email: unable to authenticate with firebase using email")
                        } else {
                            print("Email: successfully authenticated with firebase")
                            if user != nil {
                                self.completeSignIn(id: "2")
                            }
                        }
                    })
                }
            })
            
        }
    }
    
    func completeSignIn(id: String) {
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Keychain: data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
}


















