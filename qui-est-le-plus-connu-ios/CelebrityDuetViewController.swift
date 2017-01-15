//
//  CelebrityDuetViewController.swift
//  qui-est-le-plus-connu-ios
//
//  Created by Aurélien Baumann on 22/10/2016.
//  Copyright © 2016 Aurélien Baumann. All rights reserved.
//

import UIKit
import Charts

class CelebrityDuetViewController: UIViewController {
    
    var celebrityDuetPicker: CelebrityDuetPicker!
    var celebrityDuetVoter: CelebrityDuetVoter!
    var errorHandler: ErrorHandler!
    var celebrityDuet: CelebrityDuet?
    
    @IBOutlet weak var firstCelebrityNameLabel: UILabel!
    @IBOutlet weak var secondCelebrityNameLabel: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstDataSet = PieChartDataSet(values: [PieChartDataEntry(value: 10)], label: "Foo")
        let secondDataSet = PieChartDataSet(values: [PieChartDataEntry(value: 20)], label: "Bar")
        let data = PieChartData(dataSets: [firstDataSet, secondDataSet])
        pieChart.data = data
        
        pickNextCelebrityDuet()
    }
    
    private func pickNextCelebrityDuet() {
        _ = celebrityDuetPicker.pickRandomCelebrityDuet()
            .subscribe(onNext: onNextCelebrityDuet, onError: handlePickCelebrityDuetError)
    }
    
    private func onNextCelebrityDuet(_ celebrityDuet: CelebrityDuet?) {
        if let duet = celebrityDuet {
            self.celebrityDuet = duet
            updateView()
        } else {
            print("No more duets")
        }
    }
    
    private func handlePickCelebrityDuetError(error: Error) {
        errorHandler.handle(error)
    }
    
    private func updateView() {
        let duet = celebrityDuet!
        firstCelebrityNameLabel.text = duet.firstCelebrity.displayName
        secondCelebrityNameLabel.text = duet.secondCelebrity.displayName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didVoteForACelebrity(_ sender: VoteButton) {
        let duet = celebrityDuet!
        let vote = sender.isFirstCelebrity() ? duet.firstCelebrity : duet.secondCelebrity
        _ = celebrityDuetVoter.vote(duet, vote: vote).subscribe { commited in
            print("COMMITED: \(commited)\n")
        }
    }
    
}

