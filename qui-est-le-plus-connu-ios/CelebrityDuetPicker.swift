//
//  CelebrityDuetPicker.swift
//  qui-est-le-plus-connu-ios
//
//  Created by Aurélien Baumann on 18/12/2016.
//  Copyright © 2016 Aurélien Baumann. All rights reserved.
//

import Foundation
import FirebaseDatabase
import RxSwift

let DUETS_NODE_NAME = "duets"

protocol CelebrityDuetPicker {
    func pickRandomCelebrityDuet() -> Observable<CelebrityDuet?>
}

class FirebaseCelebrityDuetPicker: CelebrityDuetPicker {
    
    let databaseReference: FIRDatabaseReference
    
    init(databaseReference: FIRDatabaseReference) {
        self.databaseReference = databaseReference
    }
    
    func pickRandomCelebrityDuet() -> Observable<CelebrityDuet?> {
        let unvotedCelebrityDuetIndex = newRandomUnvotedCelebrityDuetIndex()
        return getOneCelebrityDuetDataFromDatabase(withIndex: unvotedCelebrityDuetIndex)
            .map { celebrityDuetData in return self.buildCelebrityDuetFromDictionary(celebrityDuetData)
        }
    }
    
    private func newRandomUnvotedCelebrityDuetIndex() -> String? {
        let randomNum = arc4random_uniform(6)
        return String(randomNum)
    }
    
    private func getOneCelebrityDuetDataFromDatabase(withIndex: String?) -> Observable<Dictionary<String, Any>?> {
        return Observable<Dictionary<String, Any>?>.create { observer in
            if let index = withIndex {
                self.databaseReference.child(DUETS_NODE_NAME).child(index)
                    .observeSingleEvent(of: .value, with: { snapshot in observer.onNext(snapshot.value as? Dictionary) })
                    { error in observer.onError(error) }
            } else {
                observer.onNext(nil)
            }
            return Disposables.create()
        }
    }
    
    private func buildCelebrityDuetFromDictionary(_ v: Dictionary<String,Any>?) -> CelebrityDuet? {
        guard let data = v else {
            return nil
        }
        let celebrityDuet = CelebrityDuet(
            firstCelebrity: buildOneCelebrityFromDictionary(data["first"] as! Dictionary),
            secondCelebrity: buildOneCelebrityFromDictionary(data["second"] as! Dictionary)
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
