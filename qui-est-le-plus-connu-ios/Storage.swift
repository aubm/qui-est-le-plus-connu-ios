//
//  Storage.swift
//  qui-est-le-plus-connu-ios
//
//  Created by Aurélien Baumann on 21/01/2017.
//  Copyright © 2017 Aurélien Baumann. All rights reserved.
//

import Foundation
import FirebaseStorage
import RxSwift

class Storage {
    
    let storageRef: FIRStorageReference
    
    init(storageRef: FIRStorageReference) {
        self.storageRef = storageRef
    }
    
    func downloadMultiple(_ paths: String...) -> Observable<[Data]> {
        let downloads = paths.map { path -> Observable<Data> in self.download(path) }
        return Observable<[Data]>.combineLatest(downloads) { $0 }
        
    }
    
    func download(_ path: String) -> Observable<Data> {
        return Observable<Data>.create { observer in
            self.storageRef.child(path).data(withMaxSize: 100000) { (data, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                observer.onNext(data!)
            }
            return Disposables.create()
        }
    }
    
}
