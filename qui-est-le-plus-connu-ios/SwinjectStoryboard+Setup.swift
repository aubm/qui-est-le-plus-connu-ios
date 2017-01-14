//
//  SwinjectStoryboard+Setup.swift
//  qui-est-le-plus-connu-ios
//
//  Created by Aurélien Baumann on 18/12/2016.
//  Copyright © 2016 Aurélien Baumann. All rights reserved.
//
import SwinjectStoryboard
import Firebase
import GoogleSignIn

extension SwinjectStoryboard {
    
    class func setup() {
        configureErrors()
        configureFirebase()
        configureSignIn()
        configureCelebrityDuet()
        configureUserProfile()
    }
    
    private class func configureErrors() {
        configureErrorHandler()
    }
    
    private class func configureErrorHandler() {
        defaultContainer.register(ErrorHandler.self) { r in
            ErrorHandler()
        }
    }
    
    private class func configureFirebase() {
        FIRApp.configure()
        defaultContainer.register(FIRDatabaseReference.self) { r in
            FIRDatabase.database().reference()
        }
    }
    
    private class func configureSignIn() {
        configureSignInViewController()
        configureGoogleSignIn()
        configureFirebaseAuth()
    }
    
    private class func configureSignInViewController() {
        defaultContainer.registerForStoryboard(SignInViewController.self) { r, c in
            c.googleSignIn = r.resolve(GIDSignIn.self)
            c.firebaseAuth = r.resolve(FIRAuth.self)
        }
    }
    
    private class func configureGoogleSignIn() {
        defaultContainer.register(GIDSignIn.self) { r in GIDSignIn.sharedInstance() }
    }
    
    private class func configureFirebaseAuth() {
        defaultContainer.register(FIRAuth.self) { r in FIRAuth.auth()! }
    }
    
    private class func configureCelebrityDuet() {
        configureCelebrityDuetViewController()
        configureCelebrityDuetPicker()
    }
    
    private class func configureCelebrityDuetViewController() {
        defaultContainer.registerForStoryboard(CelebrityDuetViewController.self) { r, c in
            c.celebrityDuetPicker = r.resolve(CelebrityDuetPicker.self)
            c.errorHandler = r.resolve(ErrorHandler.self)
        }
    }
    
    private class func configureCelebrityDuetPicker() {
        defaultContainer.register(CelebrityDuetPicker.self) { r in
            FirebaseCelebrityDuetPicker(
                databaseReference: r.resolve(FIRDatabaseReference.self)!
            )
        }
    }
    
    private class func configureUserProfile() {
        defaultContainer.registerForStoryboard(UserProfileViewController.self) { r, c in
            c.firebaseAuth = r.resolve(FIRAuth.self)
            c.googleSignIn = r.resolve(GIDSignIn.self)
            c.errorHandler = r.resolve(ErrorHandler.self)
        }
    }
}

