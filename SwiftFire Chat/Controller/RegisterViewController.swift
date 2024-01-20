//
//  RegisterViewController.swift
//  SwiftFire Chat
//
//  Created by Shubham on 17/01/24.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewControllerWithKeyboardManager {
    
    var authService = AuthService()
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signinLabelLink: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        authService.authStateDelegate = self
        signinLabelLink.isUserInteractionEnabled = true
        signinLabelLink.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backToSignin)))
    }
    
    @IBAction func onSignupButtonPressed(_ sender: UIButton) {
        authService.signUp(
            name: nameTextfield.text,
            email: emailTextfield.text,
            password: passwordTextfield.text
        )
    }
    
    @objc func backToSignin() {
        navigationController?.popViewController(animated: true)
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
extension RegisterViewController: AuthenticationStateDelegate {
    func onAuthenticationSuccess() {
        self.performSegue(withIdentifier: K.homeSegue, sender: self)
    }
    
    func onAuthenticationFailure(error: String) {
        print(error)
    }
}
