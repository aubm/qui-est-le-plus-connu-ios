//
//  UserProfileViewController.swift
//  qui-est-le-plus-connu-ios
//
//  Created by Aurélien Baumann on 14/01/2017.
//  Copyright © 2017 Aurélien Baumann. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class UserProfileViewController: UIViewController {
    
    var googleSignIn: GIDSignIn!
    var firebaseAuth: FIRAuth!
    var errorHandler: ErrorHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didPressedSignOut(_ sender: UIButton) {
        do {
            try firebaseAuth.signOut()
            googleSignIn.signOut()
            performSegue(withIdentifier: Constants.Segues.AfterSignOut, sender: self)
        } catch let signOutError as NSError {
            errorHandler.handle(signOutError)
        }
    }
    
}
