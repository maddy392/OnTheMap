//
//  ViewController.swift
//  OnTheMap
//
//  Created by Madhu Babu Adiki on 6/2/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    

}

