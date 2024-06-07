//
//  LogOutViewController.swift
//  OnTheMap
//
//  Created by Madhu Babu Adiki on 6/6/24.
//

import UIKit
import FacebookLogin

extension UIViewController {

    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        
        print("Logout Tapped")
        
        // Logout of Udacity session
        if UdacityClient.Auth.sessionId != "" {
            UdacityClient.deleteSession()
        } else {
            print("User is not logged in via udacity client")
        }
        
        // Logout of Facebook
        if let accessToken = AccessToken.current, !accessToken.isExpired {
            let loginManager = LoginManager()
            loginManager.logOut()
        } else {
            print("user is not logged in via FB")
        }
        
//        if let loginVC = self as? LoginViewController {
//            loginVC.setLogginIn(false)
//        }
        
        // Dismiss View
        self.dismiss(animated: true, completion: nil)
        
    }
}
