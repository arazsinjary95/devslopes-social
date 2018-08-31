//
//  FeedVC.swift
//  Devslopes-Social
//
//  Created by Araz Sinjary on 8/31/18.
//  Copyright © 2018 Araz Sinjary. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func signOutBtnPressed(_ sender: Any) {
        //here when we sign out we want to remove keychain.
        let keychainRemve = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("Keychain: id removed from keychain - \(keychainRemve)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    

}
