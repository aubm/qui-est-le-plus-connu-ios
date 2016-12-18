//
//  SwinjectStoryboard+Setup.swift
//  qui-est-le-plus-connu-ios
//
//  Created by Aurélien Baumann on 18/12/2016.
//  Copyright © 2016 Aurélien Baumann. All rights reserved.
//
import SwinjectStoryboard
import Firebase

extension SwinjectStoryboard {
    class func setup() {
        FIRApp.configure()
        let databaseReference = FIRDatabase.database().reference()
        
        defaultContainer.registerForStoryboard(CelebrityDuetViewController.self) { r, c in
            c.celebrityDuetPicker = r.resolve(CelebrityDuetPicker.self)
        }
        defaultContainer.register(CelebrityDuetPicker.self) { r in
            FirebaseCelebrityDuetPicker(databaseReference: databaseReference)
        }
    }
}

