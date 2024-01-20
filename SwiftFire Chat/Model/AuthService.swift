//
//  AuthService.swift
//  SwiftFire Chat
//
//  Created by Shubham on 19/01/24.
//

import FirebaseAuth

protocol AuthenticationStateDelegate {
    func onAuthenticationSuccess()
    func onAuthenticationFailure(error: String)
}

struct AuthService {
    
    var authStateDelegate: AuthenticationStateDelegate?
    static let currentUser = Auth.auth().currentUser
    
    func signIn(email: String?, password: String?) {
        guard let email = email, email.count > 5 else {
            authStateDelegate?.onAuthenticationFailure(error: "Enter valid email")
            return
        }
        guard let password = password, password.count > 5 else {
            authStateDelegate?.onAuthenticationFailure(error: "Enter valid password")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let e = error {
                authStateDelegate?.onAuthenticationFailure(error: e.localizedDescription)
            } else {
                authStateDelegate?.onAuthenticationSuccess()
            }
        }
    }

    func signUp(name: String?, email: String?, password: String?) {
        guard let name = name, name.count > 2 else {
            authStateDelegate?.onAuthenticationFailure(error: "Enter valid name")
            return
        }
        guard let email = email, email.count > 5 else {
            authStateDelegate?.onAuthenticationFailure(error: "Enter valid email")
            return
        }
        guard let password = password, password.count > 5 else {
            authStateDelegate?.onAuthenticationFailure(error: "Enter valid password")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if let e = error {
                authStateDelegate?.onAuthenticationFailure(error: e.localizedDescription)
            } else {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges { error in
                    if let e = error {
                        print("Error in updating name: \(e.localizedDescription)")
                    }
                }
                authStateDelegate?.onAuthenticationSuccess()
            }
        }
    }
}
