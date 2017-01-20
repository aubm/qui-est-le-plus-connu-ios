//
//  CelebrityDuetViewController.swift
//  qui-est-le-plus-connu-ios
//
//  Created by Aurélien Baumann on 22/10/2016.
//  Copyright © 2016 Aurélien Baumann. All rights reserved.
//

import UIKit
import FirebaseStorage

class CelebrityDuetViewController: UIViewController {
    
    var celebrityDuetPicker: CelebrityDuetPicker!
    var errorHandler: ErrorHandler!
    var storage: Storage!
    var celebrityDuet: CelebrityDuet?
    
    @IBOutlet weak var firstCelebrityImageView: UIImageView!
    @IBOutlet weak var secondCelebrityImageView: UIImageView!
    @IBOutlet weak var firstCelebrityNameLabel: UILabel!
    @IBOutlet weak var secondCelebrityNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickNextCelebrityDuet()
    }
    
    private func pickNextCelebrityDuet() {
        _ = celebrityDuetPicker.pickRandomCelebrityDuet()
            .subscribe(onNext: onNextCelebrityDuet, onError: errorHandler.handle)
    }
    
    private func onNextCelebrityDuet(_ celebrityDuet: CelebrityDuet?) {
        if let duet = celebrityDuet {
            updateViewWithCelebrityDuet(duet)
        } else {
            print("No more duets")
        }
    }
    
    private func updateViewWithCelebrityDuet(_ celebrityDuet: CelebrityDuet) {
        firstCelebrityNameLabel.text = celebrityDuet.firstCelebrity.displayName
        secondCelebrityNameLabel.text = celebrityDuet.secondCelebrity.displayName
        let firstCelebrityImageUri = "\(celebrityDuet.firstCelebrity.id).jpg"
        let secondCelebrityImageUri = "\(celebrityDuet.secondCelebrity.id).jpg"
        _ = storage.downloadMultiple(firstCelebrityImageUri, secondCelebrityImageUri)
            .subscribe(onNext: updateImagesData, onError: errorHandler.handle)
    }
    
    private func updateImagesData(_ data: [Data]) {
        firstCelebrityImageView.image = UIImage(data: data[0])
        secondCelebrityImageView.image = UIImage(data: data[1])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

