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
import AssetsLibrary

public var LastTab = 0



class TabBarController: UITabBarController, PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate, UITabBarControllerDelegate {
    
    // To save userdefaults
    let userdefault = NSUserDefaults.standardUserDefaults()

    // Storyboards
    let HomeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeViewController")
    let SearchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SearchViewController")
    let UploadViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("UploadViewController")
    let BookmarkViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("BookmarkViewController")
    let ProfileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProfileViewController")
    
    
    /* Show Login before displaying Tab Bar */
    override func viewDidLoad() {
        let controllers = [HomeViewController, BookmarkViewController, UploadViewController, SearchViewController, ProfileViewController]
        self.setViewControllers(controllers, animated: true)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if userdefault.stringForKey("username") == nil {
            userdefault.setObject(" ", forKey: "username")
        }

        
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
        }
    }
    
    // Shows Image Picker/Camera
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController)
    {
        // As Long as Camera isn't selected
        if tabBarController.selectedIndex != 2 {
            LastTab = tabBarController.selectedIndex
            
        } else {
      
        }
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
    
}


