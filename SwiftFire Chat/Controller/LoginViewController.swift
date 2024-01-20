//
//  LoginViewController.swift
//  SwiftFire Chat
//
//  Created by Shubham on 18/01/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewControllerWithKeyboardManager {
    
    var authService = AuthService()
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signupLabelLink: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (Auth.auth().currentUser != nil) {
            self.performSegue(withIdentifier: K.homeSegue, sender: self)
        }
        authService.authStateDelegate = self
        signupLabelLink.isUserInteractionEnabled = true
        signupLabelLink.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToSignUp)))
    }
    
    @IBAction func onSigninButtonPressed(_ sender: UIButton) {
        authService.signIn(email: emailTextfield.text, password: passwordTextfield.text)
    }
    
    @objc func goToSignUp() {
        self.performSegue(withIdentifier: K.signupSegue, sender: self)
    }

    override func onKeyboardStateChange(iskeyboardActive: Bool, height:CGFloat) {
        if iskeyboardActive {
            self.bottomConstraint?.constant = 64
        } else {
            self.bottomConstraint?.constant = height
        }
    }
}

// MARK: - Authentication Handling
extension LoginViewController: AuthenticationStateDelegate {
    func onAuthenticationSuccess() {
        self.performSegue(withIdentifier: K.homeSegue, sender: self)
    }
    
    func onAuthenticationFailure(error: String) {
        print(error)
    }
}
