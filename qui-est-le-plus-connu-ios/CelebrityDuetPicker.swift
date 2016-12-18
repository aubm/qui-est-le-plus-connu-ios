//
//  CelebrityDuetPicker.swift
//  qui-est-le-plus-connu-ios
//
//  Created by Aurélien Baumann on 18/12/2016.
//  Copyright © 2016 Aurélien Baumann. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol CelebrityDuetPicker {
    func pickRandomCelebrityDuet(_ callback: @escaping (CelebrityDuet?) -> Void, onError: @escaping (Error) -> Void)
}

class FirebaseCelebrityDuetPicker: CelebrityDuetPicker {
    
    let databaseReference: FIRDatabaseReference
    
    
    init(databaseReference: FIRDatabaseReference) {
        self.databaseReference = databaseReference
    }
    
    func pickRandomCelebrityDuet(_ callback: @escaping (CelebrityDuet?) -> Void, onError: @escaping (Error) -> Void) {
        guard let childIndex = newRandomUnvotedChildIndex() else {
            callback(nil)
            return
        }
        databaseReference.child("duets").child(childIndex).observeSingleEvent(of: .value, with: { (snapshot) in
            let celebrityDuet = self.buildCelebrityDuetFromDictionary(snapshot.value as! Dictionary)
            callback(celebrityDuet)
        }) { error in
            onError(error)
        }
    }
    
    private func newRandomUnvotedChildIndex() -> String? {
        let randomNum = arc4random_uniform(6)
        return String(randomNum)
    }
    
    private func buildCelebrityDuetFromDictionary(_ v: Dictionary<String,Any>) -> CelebrityDuet {
        let celebrityDuet = CelebrityDuet(
            firstCelebrity: buildCelebrityFromDictionary(v["first"] as! Dictionary),
            secondCelebrity: buildCelebrityFromDictionary(v["second"] as! Dictionary)
        )
        return celebrityDuet
    }
    
    private func buildCelebrityFromDictionary(_ v: Dictionary<String,Any>) -> Celebrity {
        let celebrity = Celebrity(
            id: v["id"] as! String,
            displayName: v["display_name"] as! String,
            votes: v["votes"] as! Int
        )
        return celebrity
    }
}
