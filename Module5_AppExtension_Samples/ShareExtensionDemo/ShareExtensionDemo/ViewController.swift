//
//  ViewController.swift
//  ShareExtensionDemo
//
//  Created by Neethu Krishnan on 08/10/20.
//  Copyright © 2020 DDUKK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imgTxt: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let container = UserDefaults(suiteName: "group.com.ddukk.ShareExtensionDemo")
        if let imageDict = container?.value(forKey: "img") as? NSDictionary {
            let imgData = imageDict["imgData"] as! Data
            let txtInput = imageDict["name"] as! String
            imgView.image = UIImage(data: imgData)
            imgTxt.text = txtInput
        }
    }
}

