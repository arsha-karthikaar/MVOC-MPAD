//
//  TodayViewController.swift
//  TodayTimer
//
//  Created by Neethu Krishnan on 13/10/20.
//  Copyright © 2020 DDUKK. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var lbTimerNum: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            let randomNumber = Int.random(in: 1...15)
            self.lbTimerNum.text = String(randomNumber)
            print("Number: \(randomNumber)")

            if randomNumber == 10 {
                timer.invalidate()
            }
        }
        
    }
        
    @IBAction func didTapOpen(_ sender: Any) {
        let url = URL(string: "todayExtension://")
        self.extensionContext?.open(url!, completionHandler: nil)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
