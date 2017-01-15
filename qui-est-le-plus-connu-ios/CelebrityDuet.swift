//
//  CelebrityDuet.swift
//  qui-est-le-plus-connu-ios
//
//  Created by Aurélien Baumann on 18/12/2016.
//  Copyright © 2016 Aurélien Baumann. All rights reserved.
//

import Foundation

struct CelebrityDuet {
    var index: String
    var firstCelebrity: Celebrity
    var secondCelebrity: Celebrity
}

struct Celebrity {
    var id: String
    var displayName: String
    var votes: Int
}
