//
//  CreateAccountViewController.swift
//  InstaClone
//
//  Created by Cindy Barnsdale on 6/20/16.
//  Copyright © 2016 Caleb Talbot. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class CreateAccountViewController: UIViewController {

    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    
    let usersRef = FIRDatabase.database().reference().child("users")

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func finishButtonTapped(sender: AnyObject) {
        
        FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: passwordField.text!) { (user, error) in
            
            if error == nil {
                print("User Created")
                
                let currentUserUID = FIRAuth.auth()?.currentUser?.uid
                
                
                if let userID = currentUserUID {
                        self.usersRef.child(userID).child("profilepicture").setValue("https://firebasestorage.googleapis.com/v0/b/fauxstagram.appspot.com/o/daff35_94ba58407fd14cbfb3a0394ff34127be.png_256.png?alt=media&token=10480fef-d3bd-43a1-9f15-24ba577a9f3e")
                        self.usersRef.child(userID).child("name").setValue(self.nameField.text)
                        self.usersRef.child(userID).child("email").setValue(self.emailField.text)
                        self.usersRef.child(userID).child("address").setValue(self.addressField.text)
                }
                
                let loginStoryBoard: UIStoryboard = UIStoryboard(name: "Feed", bundle: nil)

                
                let mainViewController: UITabBarController = loginStoryBoard.instantiateViewControllerWithIdentifier("TabBarView") as! UITabBarController
                
                self.presentViewController(mainViewController, animated: true, completion: nil)            }
                
            else {
                print(error?.description)
                print("User Not Created")
                
            }
        }
    }
}
