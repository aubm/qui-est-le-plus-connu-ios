//
//  CelebrityDuet.swift
//  qui-est-le-plus-connu-ios
//
//  Created by Aurélien Baumann on 22/10/2016.
//  Copyright © 2016 Aurélien Baumann. All rights reserved.
//

import Foundation

struct CelebrityDuet {
    let firstCelebrity: Celebrity
    let secondCelebrity: Celebrity
}

struct Celebrity {
    let name: String
    let slug: String
    let imageUrl: String
}
