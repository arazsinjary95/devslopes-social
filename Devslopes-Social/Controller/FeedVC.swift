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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: UIImageView!
    @IBOutlet weak var captionField: UITextField!
  
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
 
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.instance.REF_POSTS.observe(.value) { (snapshot) in
            
            self.posts = [] //this for when duplicate posts!
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as? PostCell {
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString){
                cell.configureCell(post: post, img: img)
             
            } else {
                cell.configureCell(post: post)
                
            }
            return cell
         } else {
           return PostCell()
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            imageSelected = true
        } else {
            print("ImagePicker: a valid image wasn't selscted")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func imagePickerAdd(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func postBtnPressed(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else {
            print("Post: caption must be seleted")
            return
        }
        
        guard let img = imageAdd.image, imageSelected == true else {
            print("Post: as image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let ref = DataService.instance.REF_POSTS_IMAGES.child(imgUid)
            ref.putData(imgData, metadata: metadata) { (meta, error) in
                
                guard let meta = meta else {
                    return print("Post: unable to upload image to firebase storage")
                }
                
                ref.downloadURL(completion: { (url, error) in
                    if let downloadURL = url {
                        self.postToFirebase(imageUrl: String(describing: downloadURL))
                    }
                })
            }
                
//                if error != nil {
//                    print("Post: unable to upload image to firebase storage")
//                } else {
//                    print("Post: successfully uploaded image to firebase storage")
//                    let downloadURl = meta?.downloadURl()?.absoluteString
//                    if let url = downloadURl {
//                        postToFirebase(imageUrl: url)
//                    }
//                }
            
        }
    }
    
    func postToFirebase(imageUrl: String) {
        let post: Dictionary<String, Any> = [
            "caption": captionField.text as Any,
            "imageUrl": imageUrl,
            "likes": 0
        ]
        
        let firebasePost = DataService.instance.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        
        tableView.reloadData()
    }
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        //here when we sign out we want to remove keychain.
        let keychainRemve = KeychainWrapper.defaultKeychainWrapper.removeObject(forKey: KEY_UID)
        print("Keychain: id removed from keychain - \(keychainRemve)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    

}
