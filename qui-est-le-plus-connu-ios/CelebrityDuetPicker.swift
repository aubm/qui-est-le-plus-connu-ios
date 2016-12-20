//
//  CelebrityDuetPicker.swift
//  qui-est-le-plus-connu-ios
//
//  Created by Aurélien Baumann on 18/12/2016.
//  Copyright © 2016 Aurélien Baumann. All rights reserved.
//

import Foundation
import FirebaseDatabase

let DUETS_NODE_NAME = "duets"

protocol CelebrityDuetPicker {
    func pickRandomCelebrityDuet(_ callback: @escaping (CelebrityDuet?) -> Void, onError: @escaping (Error) -> Void)
}

class FirebaseCelebrityDuetPicker: CelebrityDuetPicker {
    
    let databaseReference: FIRDatabaseReference
    var pickRandomCelebrityDuetCallback: ((CelebrityDuet?) -> Void)!
    
    
    init(databaseReference: FIRDatabaseReference) {
        self.databaseReference = databaseReference
    }
    
    func pickRandomCelebrityDuet(_ callback: @escaping (CelebrityDuet?) -> Void, onError: @escaping (Error) -> Void) {
        pickRandomCelebrityDuetCallback = callback
        
        guard let unvotedCelebrityDuetIndex = newRandomUnvotedCelebrityDuetIndex() else {
            pickRandomCelebrityDuetCallback(nil)
            return
        }
        
        getOneCelebrityDuetFromDatabase(
            withIndex: unvotedCelebrityDuetIndex,
            onSuccess: provideCelebrityDuetToCaller,
            onError: onError)
    }
    
    private func newRandomUnvotedCelebrityDuetIndex() -> String? {
        let randomNum = arc4random_uniform(6)
        return String(randomNum)
    }
    
    private func provideCelebrityDuetToCaller(celebrityDuetData: Dictionary<String, Any>) {
        pickRandomCelebrityDuetCallback(buildCelebrityDuetFromDictionary(celebrityDuetData))
    }
    
    private func getOneCelebrityDuetFromDatabase(withIndex: String, onSuccess: @escaping (Dictionary<String, Any>) -> Void, onError: @escaping (Error) -> Void) {
        databaseReference.child(DUETS_NODE_NAME).child(withIndex).observeSingleEvent(of: .value, with: { snapshot in
            onSuccess(snapshot.value as! Dictionary)
        }) { error in
            onError(error)
        }
    }
    
    private func buildCelebrityDuetFromDictionary(_ v: Dictionary<String,Any>) -> CelebrityDuet {
        let celebrityDuet = CelebrityDuet(
            firstCelebrity: buildOneCelebrityFromDictionary(v["first"] as! Dictionary),
            secondCelebrity: buildOneCelebrityFromDictionary(v["second"] as! Dictionary)
        )
        return celebrityDuet
    }
    
    private func buildOneCelebrityFromDictionary(_ v: Dictionary<String,Any>) -> Celebrity {
        let celebrity = Celebrity(
            id: v["id"] as! String,
            displayName: v["display_name"] as! String,
            votes: v["votes"] as! Int
        )
        return celebrity
    }
}
