//
//  CelebritiesService.swift
//  qui-est-le-plus-connu-ios
//
//  Created by Aurélien Baumann on 22/10/2016.
//  Copyright © 2016 Aurélien Baumann. All rights reserved.
//

import Foundation

class CelebritiesService {
    
    func newCelebrityDuet() -> CelebrityDuet {
        return CelebrityDuet(
            firstCelebrity: Celebrity(name: "Alexandre Astier", slug: "alexandre-astier", imageUrl: "https://pbs.twimg.com/profile_images/378800000730682848/4de6e7d44a5e2ef534875222796d94d2.jpeg"),
            secondCelebrity: Celebrity(name: "Gérard Depardieu", slug: "gerard-depardieu", imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9f/G%C3%A9rard_Depardieu_Cannes_2010.jpg/220px-G%C3%A9rard_Depardieu_Cannes_2010.jpg")
        )
    }
    
    func vote(duet: CelebrityDuet, choice: Celebrity, delegate: VoterDelegate) {
        delegate.voteIsSubmitted()
    }
    
}
