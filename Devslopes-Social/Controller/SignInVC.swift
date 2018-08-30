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

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func facebookBtnPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                print("Araz: Unable to authenticate with facebook - \(error!)")
            } else if result?.isCancelled == true {
                print("Araz: User cancelled facebook authentication")
            } else {
                print("Araz: Successfully autheticated with facebook")
                let credentail = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credentail)
            }
        }
        
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            
            if error != nil {
                print("Araz: Unable to authenticate with firebase - \(error!)")
            } else {
                print("Araz: Successfully authenticated with firebase")
            }
        }
    }

}

