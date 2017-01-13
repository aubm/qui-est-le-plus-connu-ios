//
//  AppDelegate+GoogleSignIn.swift
//  qui-est-le-plus-connu-ios
//
//  Created by Aurélien Baumann on 13/01/2017.
//  Copyright © 2017 Aurélien Baumann. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn
import SwinjectStoryboard

extension AppDelegate: GIDSignInDelegate {
    
    var googleSignIn: GIDSignIn {
        get { return SwinjectStoryboard.defaultContainer.resolve(GIDSignIn.self)! }
    }
    
    var firebaseAuth: FIRAuth {
        get { return SwinjectStoryboard.defaultContainer.resolve(FIRAuth.self)! }
    }
    
    var errorHandler: ErrorHandler {
        get { return SwinjectStoryboard.defaultContainer.resolve(ErrorHandler.self)! }
    }
    
    func configureGoogleSignIn() {
        googleSignIn.clientID = FIRApp.defaultApp()?.options.clientID
        googleSignIn.delegate = self
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        return configureGoogleSignInCallbackHandler(url, sourceApplication: sourceApplication, annotation: [:])
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return configureGoogleSignInCallbackHandler(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    private func configureGoogleSignInCallbackHandler(_ url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return googleSignIn.handle(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            errorHandler.handle(error)
            return
        }
        
        guard let authentication = user.authentication else {
            return
        }
        
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        firebaseAuth.signIn(with: credential) { (user, error) in
            if let error = error {
                self.errorHandler.handle(error)
                return
            }
        }
    }
    
}
