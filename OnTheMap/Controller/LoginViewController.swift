//
//  ViewController.swift
//  OnTheMap
//
//  Created by Madhu Babu Adiki on 6/2/24.
//

import UIKit
import FacebookLogin

class LoginViewController: UIViewController, LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginKit.FBLoginButton, didCompleteWith result: FBSDKLoginKit.LoginManagerLoginResult?, error: (any Error)?) {
        if let error = error {
            print("Login failed with error: \(error.localizedDescription)")
            return
        }
        
        guard let result = result, !result.isCancelled else {
            print("Login was cancelled")
                return
        }
        
        // Successful login
        print("Logged in with granted permissions: \(result.grantedPermissions)")
        
        // Get the access token
        if let accessToken = AccessToken.current {
            print("Access Token: \(accessToken.tokenString)")
//            print(accessToken.userID)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.performSegue(withIdentifier: "completeLogin", sender: self)
            })

            // You can use the access token here, e.g., send it to your server
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
        print("Logged Out")
    }
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginWithFBButton: FBLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        loginWithFBButton.addTarget(self, action: #selector(loginWithFbButtonClicked), for: .touchUpInside)
        loginWithFBButton.delegate = self
        loginWithFBButton.permissions = ["public_profile", "email"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        UdacityClient.udacityLogin(username: emailTextField.text ?? "", password: passwordTextField.text ?? "") { success, error in
            if success {
                print("Login Success")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "completeLogin", sender: nil)
                }
            } else {
                print("Login Failed")
                DispatchQueue.main.async {
                    self.showLoginFailure(message: error?.localizedDescription ?? "")
                }
            }
        }
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
//    @objc func loginWithFbButtonClicked() {
//        let loginManager = LoginManager()
//        loginManager.logIn(permissions: ["public_profile"], from: self) { result, error in
//            if let error = error {
//                print("Encountered Erorr: \(error)")
//            } else if let result = result, result.isCancelled {
//                print("Cancelled")
//            } else {
//                print("Logged In")
//            }
//        }
//    }
    
}
