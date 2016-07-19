//
//  TabBarController.swift
//  shoutaround
//
//  Created by Wei Zou Ang on 7/18/16.
//  Copyright © 2016 Wei Zou Ang. All rights reserved.
//

//import Cocoa
import Parse
import ParseUI

public var LastTab = 0

class TabBarController: UITabBarController, PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate, UITabBarControllerDelegate, FusumaDelegate {
    
    // To save userdefaults
    let userdefault = NSUserDefaults.standardUserDefaults()

    // Storyboards
    let HomeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeViewController")
    let SearchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SearchViewController")
    let CameraViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CameraViewController")
    let BookmarkViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("BookmarkViewController")
    let ProfileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProfileViewController")
    
    /* Show Login before displaying Tab Bar */
    override func viewDidLoad() {
        
        self.delegate = self
        
        
        if (PFUser.currentUser() == nil) {
            let loginViewController = LoginViewController()
            loginViewController.delegate = self
            loginViewController.fields = [PFLogInFields.UsernameAndPassword,
                PFLogInFields.LogInButton,
                PFLogInFields.SignUpButton,
                PFLogInFields.PasswordForgotten,
                PFLogInFields.Facebook,
                PFLogInFields.Twitter
            ]
            loginViewController.emailAsUsername = true
            loginViewController.signUpController?.delegate = self
            self.presentViewController(loginViewController, animated: false, completion: nil)
        } else {
            
            
            
            //let controllers = [HomeViewController, SearchViewController, CameraViewController, BookmarkViewController, ProfileViewController]
            //self.setViewControllers(controllers, animated: true)
            

            

        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if userdefault.stringForKey("username") == nil {
            userdefault.setObject(" ", forKey: "username")
        }

        

    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController)
    {
        // As Long as Camera isn't selected
        if tabBarController.selectedIndex != 2 {
            LastTab = tabBarController.selectedIndex
            
        } else {
            showFusuma()
            self.selectedIndex = LastTab
            
        }
        print(self.selectedIndex)
        
    }
    
    
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        userdefault.setObject(logInController.logInView?.usernameField?.text, forKey: "username")
        presentLoggedInAlert()
        
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        userdefault.setObject(signUpController.signUpView?.usernameField!.text, forKey: "username")
        presentLoggedInAlert()
        
    }
    
    func presentLoggedInAlert() {
        let alertController = UIAlertController(title: "You're logged in", message: "Welcome to Shoutaround", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
}
    
    func showFusuma() {
        
        let fusuma = Fusuma()
        fusuma.delegate = self
        
        self.presentViewController(fusuma, animated: true, completion: nil)
        

    }
    
    
    
    func fusumaImageSelected(image: UIImage) {
        
        imageSelected = image
        
        print("Image selected")
        
        // self.shouldPerformSegueWithIdentifier("uploadImageSegue", sender: self)
        
        
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage) {
        
        print("Called just after FusumaViewController is dismissed.")
        
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
        
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }

    
    
}


