//
//  SignInViewController.swift
//  qui-est-le-plus-connu-ios
//
//  Created by Aurélien Baumann on 13/01/2017.
//  Copyright © 2017 Aurélien Baumann. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate {
    
    var googleSignIn: GIDSignIn!
    var firebaseAuth: FIRAuth!
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleSignIn.uiDelegate = self
        firebaseAuth.addStateDidChangeListener(handleUserStateChange)
    }
    
    private func handleUserStateChange(auth: FIRAuth, user: FIRUser?) {
        if user == nil { return }
        self.performSegue(withIdentifier: Constants.Segues.AfterSignIn, sender: self)
    }
    
}
