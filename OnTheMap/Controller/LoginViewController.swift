//
//  ViewController.swift
//  OnTheMap
//
//  Created by Madhu Babu Adiki on 6/2/24.
//

import UIKit
import FacebookLogin

class LoginViewController: UIViewController, LoginButtonDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginWithFBButton: FBLoginButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginWithFBButton.delegate = self
        loginWithFBButton.permissions = ["public_profile", "email"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    // MARK: Login with FB
    func loginButton(_ loginButton: FBSDKLoginKit.FBLoginButton, didCompleteWith result: FBSDKLoginKit.LoginManagerLoginResult?, error: (any Error)?) {
//        setLogginIn(true)
        if let error = error {
            print("Login failed with error: \(error.localizedDescription)")
//            setLogginIn(false)
            return
        }
        
        guard let result = result, !result.isCancelled else {
            print("Login was cancelled")
//            setLogginIn(false)
                return
        }
        
        // Successful login
        print("Logged in with granted permissions: \(result.grantedPermissions)")
        
        // Get the access token
        if let _ = AccessToken.current {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.performSegue(withIdentifier: "completeLogin", sender: self)
            })
        }
    }
    
    // Logout
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
//        setLogginIn(false)
        print("Logged Out")
    }
    
    // MARK: Login using username and password
    @IBAction func loginButtonTapped(_ sender: Any) {
        UdacityClient.udacityLogin(username: emailTextField.text ?? "", password: passwordTextField.text ?? "") { success, error in
            if success {
                print("Login Success")
                UdacityClient.getPublicUserData()
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "completeLogin", sender: nil)
                }
            } else {
                print("Login Failed")
                DispatchQueue.main.async {
                    self.showLoginFailure(message: error?.localizedDescription ?? "")
//                    self.setLogginIn(false)
                }
            }
        }
    }
    
    // MARK: Alert with error messge on wrong credentials
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
}
