//
//  VoteButton.swift
//  qui-est-le-plus-connu-ios
//
//  Created by Aurélien Baumann on 14/01/2017.
//  Copyright © 2017 Aurélien Baumann. All rights reserved.
//

import UIKit

class VoteButton: UIButton {
    
    func isFirstCelebrity() -> Bool {
        return tag == 0
    }
    
}
