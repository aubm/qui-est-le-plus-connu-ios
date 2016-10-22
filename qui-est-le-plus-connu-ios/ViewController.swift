//
//  ViewController.swift
//  qui-est-le-plus-connu-ios
//
//  Created by Aurélien Baumann on 22/10/2016.
//  Copyright © 2016 Aurélien Baumann. All rights reserved.
//

import UIKit

class ViewController: UIViewController,VoterDelegate,CelebrityDuetProviderDelegate {
    
    let celebrityService = AppProvider.celebrityService()
    var duet: CelebrityDuet? = nil;
    
    @IBOutlet weak var firstCelebrityImage: UIImageView!
    @IBOutlet weak var secondCelebrityImage: UIImageView!
    @IBOutlet weak var firstCelebrityImageLoader: UIActivityIndicatorView!
    @IBOutlet weak var secondCelebrityImageLoader: UIActivityIndicatorView!
    @IBOutlet weak var firstCelebrityName: UILabel!
    @IBOutlet weak var secondCelebrityName: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadCelebrityDuet()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCelebrityDuet() {
        showFirstCelebrityImageLoader()
        showSecondCelebrityImageLoader()
        
        celebrityService.provideCelebrityDuet(delegate: self)
    }
    
    func onNewCelebrityDuet(_duet: CelebrityDuet) {
        duet = _duet
        
        DispatchQueue.main.async {
            self.firstCelebrityName.text = self.duet!.firstCelebrity.name
            self.secondCelebrityName.text = self.duet!.secondCelebrity.name
        }
        
        firstCelebrityImage.downloadedFrom(link: duet!.firstCelebrity.imageUrl, callback: {
            DispatchQueue.main.async { self.hideFirstCelebrityImageLoader() }
        })
                
        secondCelebrityImage.downloadedFrom(link: duet!.secondCelebrity.imageUrl, callback: {
            DispatchQueue.main.async { self.hideSecondCelebrityImageLoader() }
        })
    }
    
    func showFirstCelebrityImageLoader() {
        firstCelebrityImageLoader.isHidden = false
    }
    
    func showSecondCelebrityImageLoader() {
        secondCelebrityImageLoader.isHidden = false
    }
    
    func hideFirstCelebrityImageLoader() {
        firstCelebrityImageLoader.isHidden = true
    }
    
    func hideSecondCelebrityImageLoader() {
        secondCelebrityImageLoader.isHidden = true
    }
    
    @IBAction func vote(_ sender: UIButton) {
        var choice: Celebrity? = nil
        switch sender.tag {
        case 0:
            choice = duet?.firstCelebrity
        case 1:
            choice = duet?.secondCelebrity
        default:
            choice = nil
        }
        
        celebrityService.vote(duet: duet!, choice: choice!, delegate: self)
    }
    
    func voteIsSubmitted() {
        loadCelebrityDuet()
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, callback: @escaping () -> Void) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            defer { callback() }
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit, callback: @escaping () -> Void) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode, callback: callback)
    }
}
