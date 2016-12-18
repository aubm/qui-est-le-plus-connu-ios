//
//  CelebrityDuetViewController.swift
//  qui-est-le-plus-connu-ios
//
//  Created by Aurélien Baumann on 22/10/2016.
//  Copyright © 2016 Aurélien Baumann. All rights reserved.
//

import UIKit

class CelebrityDuetViewController: UIViewController {
    
    var celebrityDuetPicker: CelebrityDuetPicker!
    var celebrityDuet: CelebrityDuet?
    
    @IBOutlet weak var firstCelebrityNameLabel: UILabel!
    @IBOutlet weak var secondCelebrityNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickNextCelebrityDuet()
    }
    
    func pickNextCelebrityDuet() {
        celebrityDuetPicker.pickRandomCelebrityDuet(
            {celebrityDuet in self.updateViewWithCelebrityDuet(celebrityDuet!) },
            onError: {error in print(error.localizedDescription)}
        )
    }
    
    private func updateViewWithCelebrityDuet(_ celebrityDuet: CelebrityDuet) {
        firstCelebrityNameLabel.text = celebrityDuet.firstCelebrity.displayName
        secondCelebrityNameLabel.text = celebrityDuet.secondCelebrity.displayName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

