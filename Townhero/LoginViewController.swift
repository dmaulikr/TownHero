//
//  LoginViewController.swift
//  InstaClone
//
//  Created by Cindy Barnsdale on 6/20/16.
//  Copyright © 2016 Caleb Talbot. All rights reserved.
//

import UIKit
import FBSDKLoginKit
// User FirebaseAuth to allow firebase to see users logging in.
import Firebase
import FirebaseAuth


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    
    
    var loginButton: FBSDKLoginButton = FBSDKLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginButton.hidden = true
        
        
        
        
        
        // This code will check to see if the user is signed in or not. Located in firebase manage users: Step 1.
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if user != nil {
                // If the user is signed in, show the home page.
                
                let loginStoryBoard: UIStoryboard = UIStoryboard(name: "Map", bundle: nil)
                // Uncomment this when we get feed done and add HomeView as the storyboard id.
                
                let MapViewController: UIViewController = loginStoryBoard.instantiateViewControllerWithIdentifier("TabBarView")
                
                self.presentViewController(MapViewController, animated: false, completion: nil)
                
            } else {
                // If user is signed out, show the login button.
                
                // This is the facebook login button.
        //       self.loginButton.center = self.view.center
                self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
                self.loginButton.delegate = self
         //      self.view!.addSubview(self.loginButton)
                
                self.loginButton.hidden = false
                
                
                
            }
            
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        self.view!.addGestureRecognizer(tap)


        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if(FBSDKAccessToken.currentAccessToken() != nil) {
    //        performSegueWithIdentifier("loginToFeed", sender: self)
        } else {
            print("Must Log In")
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        
        self.loginButton.hidden = true
//        if self.loginButton.hidden == true {
//            } else {
//            print("Facebook Not Logged In")
//        }
        
        activitySpinner.startAnimating()
        
        // Code to deal with users who hit cancel on the facebook login access.
        if (error != nil)
        {
            // If error occurs, login button appears
            self.loginButton.hidden = false
            activitySpinner.stopAnimating()
        }
        else if(result.isCancelled) {
            // handle the cancel event, show the login button
            self.loginButton.hidden = false
            activitySpinner.stopAnimating()
            
        } else {  // User hits OK to grant rights to use Facebook Login.
            print("user logged in")

            // Since Firebase cannot see users logged in even with facebook set up correctly, we have to add this code. Located in guides, auth, facebook, step 4.
            
            // This is getting an access token for the signed-in user and exchanging it for a Firebase credential:
            
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            
            
            // Step 5 authenticate with Firebase using the Firebase credential
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                print("user logged into firebase")
                self.performSegueWithIdentifier("loginToFeed", sender: self)

                
                
                
            }
            
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("user logged out")
    }
    
    
   
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
  
            FIRAuth.auth()?.signInWithEmail(userNameField.text!, password: passwordField.text!) { (user, error) in
                
                if error == nil {
                    print("User Logged In")
                    
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = storyboard.instantiateViewControllerWithIdentifier("ProfileView")
//                    self.presentViewController(vc, animated: true, completion: nil)
                       self.performSegueWithIdentifier("loginToFeed", sender: self)
                           
                }
                else {
                    print("Invalid Login")
                    
                    let alertController = UIAlertController(title: nil, message: "Invalid login", preferredStyle: .Alert)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                        // ...
                    }
                    alertController.addAction(cancelAction)
                    
                    let OKAction = UIAlertAction(title: "Try Again", style: .Default) { (action) in
                        // ...
                    }
                    alertController.addAction(OKAction)
//
//                    let destroyAction = UIAlertAction(title: "Use Facebook", style: .Default) { (action) in
//                        print(action)
//                      
//                        
//                    }
//                    alertController.addAction(destroyAction)
                    
                    self.presentViewController(alertController, animated: true) {
                        // ...
                    }
                }
                
            }
        }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        print("segue to \(segue.identifier) \(segue.destinationViewController)")
//    }

    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}

}

