//
//  CelebrityDuetVoter.swift
//  qui-est-le-plus-connu-ios
//
//  Created by Aurélien Baumann on 14/01/2017.
//  Copyright © 2017 Aurélien Baumann. All rights reserved.
//

import Foundation
import FirebaseDatabase
import RxSwift

class CelebrityDuetVoter {
    
    let databaseReference: FIRDatabaseReference
    
    init(databaseReference: FIRDatabaseReference) {
        self.databaseReference = databaseReference
    }
    
    func vote(_ duet: CelebrityDuet, vote: Celebrity) -> Observable<Bool> {
        let position = (duet.firstCelebrity.id == vote.id) ? "first" : "second"
        let childPath = "\(DUETS_NODE_NAME)/\(duet.index)/\(position)/votes"
        return Observable<Bool>.create { observer in
            self.databaseReference.child(childPath).runTransactionBlock({ data -> FIRTransactionResult in
                let votes = data.value as? Int ?? 0
                data.value = votes + 1
                return FIRTransactionResult.success(withValue: data)
            })
            { (error, commited, _) in
                observer.onNext(commited)
            }
            return Disposables.create()
        }
    }
}
