//
//  CelebritiesService.swift
//  qui-est-le-plus-connu-ios
//
//  Created by Aurélien Baumann on 22/10/2016.
//  Copyright © 2016 Aurélien Baumann. All rights reserved.
//

import Foundation

class CelebritiesService {
    
    func provideCelebrityDuet(delegate: CelebrityDuetProviderDelegate) {
        loadCelebrities { (celebrities) in
            let duet = self.newRandomCelebrityDuet(celebrities: celebrities)
            delegate.onNewCelebrityDuet(_duet: duet)
        }
    }
    
    func vote(duet: CelebrityDuet, choice: Celebrity, delegate: VoterDelegate) {
        delegate.voteIsSubmitted()
    }
    
    private func loadCelebrities(callback: @escaping (Array<Celebrity>) -> Void) {
        
        let request = URLRequest(url: URL(string: "http://localhost:3000/celebrities")!)
        let session = URLSession.shared
        
        session.dataTask(with: request) {data, response, err in
            var celebrities = Array<Celebrity>()
            
            defer { callback(celebrities) }
            
            guard
                let json = try? JSONSerialization.jsonObject(with: data!)
                else { return }
            for field in json as? [AnyObject] ?? [] {
                let celeb = Celebrity(
                    name: field["name"] as? String ?? "",
                    slug: field["slug"] as? String ?? "",
                    imageUrl: field["image_url"] as? String ?? ""
                )
                celebrities.append(celeb)
            }
        }.resume()
        
    }
    
    private func newRandomCelebrityDuet(celebrities: Array<Celebrity>) -> CelebrityDuet {
        
        let randInt1 = Int(arc4random_uniform(UInt32(celebrities.count)))
        var randInt2: Int = 0;
        repeat {
            randInt2 = Int(arc4random_uniform(UInt32(celebrities.count)))
        } while randInt1 == randInt2;
        
        return CelebrityDuet(firstCelebrity: celebrities[randInt1], secondCelebrity: celebrities[randInt2])
    }
    
}
