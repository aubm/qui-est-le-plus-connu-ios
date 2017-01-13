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
let TOTAL_DUETS_NODE_NAME = "total_duets"

protocol CelebrityDuetPicker {
    func pickRandomCelebrityDuet() -> Observable<CelebrityDuet?>
}

class FirebaseCelebrityDuetPicker: CelebrityDuetPicker {
    
    let databaseReference: FIRDatabaseReference
    
    init(databaseReference: FIRDatabaseReference) {
        self.databaseReference = databaseReference
    }
    
    func pickRandomCelebrityDuet() -> Observable<CelebrityDuet?> {
        return getUnvotedIndexes()
            .map(selectOneRandomIndexFromUnvotedIndexList)
            .flatMap(getOneCelebrityDuetData)
            .map(buildCelebrityDuetFromData)
    }
    
    private func getUnvotedIndexes() -> Observable<[Int]> {
        return Observable.zip(getNumberOfCelebrityDuets(), getUserVotedIndexes()) { (numberOfCelebrityDuets, userVotedIndexes) in
            let votedIndexes = Set(userVotedIndexes)
            var indexes = Set(0...numberOfCelebrityDuets-1)
            indexes.subtract(votedIndexes)
            return indexes.sorted()
        }
    }
    
    private func getNumberOfCelebrityDuets() -> Observable<Int> {
        return Observable<Int>.create { observer in
            self.databaseReference.child(TOTAL_DUETS_NODE_NAME)
                .observeSingleEvent(of: .value, with: { snapshot in
                    observer.onNext(snapshot.value as! Int)
                })
                { error in observer.onError(error) }
            return Disposables.create()
        }
    }
    
    private func getUserVotedIndexes() -> Observable<[Int]> {
        // TODO: implement
        return Observable.just([])
    }
    
    private func selectOneRandomIndexFromUnvotedIndexList(_ unvotedIndexes: [Int]) -> String? {
        if  unvotedIndexes.count  == 0 {
            return nil
        }
        let i = Int(arc4random_uniform(UInt32(unvotedIndexes.count)))
        return String(unvotedIndexes[i])
    }
    
    private func getOneCelebrityDuetData(_ withIndex: String?) -> Observable<Dictionary<String,Any>?> {
        return Observable<Dictionary<String,Any>?>.create { observer in
            if let index = withIndex {
                self.databaseReference.child(DUETS_NODE_NAME).child(index)
                    .observeSingleEvent(of: .value, with: { snapshot in
                        observer.onNext(snapshot.value as? Dictionary)
                    })
                    { error in observer.onError(error) }
            } else {
                observer.onNext(nil)
            }
            return Disposables.create()
        }
    }
    
    private func buildCelebrityDuetFromData(_ v: Dictionary<String,Any>?) -> CelebrityDuet? {
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
